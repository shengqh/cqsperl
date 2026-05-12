#!/usr/bin/env python3

"""Convert dbNSFP into an ANNOVAR-style table with only SIFT/Polyphen2 fields."""

from __future__ import annotations

import argparse
import gzip
import sys
from typing import Iterable, TextIO


BASE_OUTPUT_COLUMNS = ("#Chr", "Start", "End", "Ref", "Alt")
TARGET_COLUMNS = ("SIFT4G_pred", "Polyphen2_HVAR_pred")


def build_argument_parser() -> argparse.ArgumentParser:
	parser = argparse.ArgumentParser(
		description=(
			"Stream dbNSFP rows into ANNOVAR generic format, keeping only "
			"SIFT4G_pred and Polyphen2_HVAR_pred."
		)
	)
	parser.add_argument(
		"input",
		help="Input dbNSFP file. Plain text and .gz files are supported.",
	)
	parser.add_argument(
		"output",
		help=(
			"Output path such like hg38_dbnsfp531a.txt."
		),
	)
	parser.add_argument(
		"--max-rows",
		type=int,
		default=None,
		help="Stop after writing this many data rows. Useful for smoke tests.",
	)
	parser.add_argument(
		"--progress-every",
		type=int,
		default=1_000_000,
		help="Report progress to stderr every N data rows. Use 0 to disable.",
	)
	return parser

def open_reader(path: str) -> TextIO:
	if path.endswith(".gz"):
		return gzip.open(path, "rt", encoding="utf-8", newline="")
	return open(path, "rt", encoding="utf-8", newline="")


def open_writer(path: str) -> tuple[TextIO, str]:
	return open(path, "wt", encoding="utf-8", newline=""), path


def find_column_index(header_fields: list[str], candidates: Iterable[str]) -> int:
	for candidate in candidates:
		try:
			return header_fields.index(candidate)
		except ValueError:
			continue
	raise ValueError(f"Missing required column. Tried: {', '.join(candidates)}")


def trim_common_affixes(ref: str, alt: str) -> tuple[int, str, str]:
	if ref == alt:
		return 0, ref, alt

	prefix = 0
	max_prefix = min(len(ref), len(alt))
	while prefix < max_prefix and ref[prefix] == alt[prefix]:
		prefix += 1

	ref_end = len(ref)
	alt_end = len(alt)
	while ref_end > prefix and alt_end > prefix and ref[ref_end - 1] == alt[alt_end - 1]:
		ref_end -= 1
		alt_end -= 1

	return prefix, ref[prefix:ref_end], alt[prefix:alt_end]


def annovar_coordinates(pos_text: str, ref: str, alt: str) -> tuple[int, int, str, str]:
	pos = int(pos_text)
	ref = ref.strip()
	alt = alt.strip()

	if ref in {"", "."}:
		ref = "-"
	if alt in {"", "."}:
		alt = "-"

	if ref == "-" and alt == "-":
		return pos, pos, ref, alt

	if ref == "-":
		return pos, pos, ref, alt

	if alt == "-":
		return pos, pos + len(ref) - 1, ref, alt

	prefix, ref_core, alt_core = trim_common_affixes(ref, alt)

	if not ref_core and not alt_core:
		return pos, pos + len(ref) - 1, ref, alt

	if not ref_core:
		start = pos + prefix - 1
		return start, start, "-", alt_core

	start = pos + prefix
	end = start + len(ref_core) - 1
	if not alt_core:
		return start, end, ref_core, "-"

	return start, end, ref_core, alt_core


def annotation_value_is_empty(value: str) -> bool:
	text = value.strip()
	if text in {"", "."}:
		return True
	return all(part in {"", "."} for part in text.split(";"))


def split_annotation_values(value: str) -> list[str]:
	return [part.strip() for part in value.split(";") if part.strip() and part.strip() != "."]


def collapse_sift_prediction(value: str) -> str:
	values = split_annotation_values(value)
	if "D" in values:
		return "D"
	if "T" in values:
		return "T"
	return values[0] if values else "."


def collapse_polyphen_prediction(value: str) -> str:
	values = split_annotation_values(value)
	for prediction in ("D", "P", "B"):
		if prediction in values:
			return prediction
	return values[0] if values else "."


def convert(input_path: str, output_path: str, max_rows: int | None, progress_every: int) -> tuple[str, int, list[str]]:
	reader = open_reader(input_path)
	writer, resolved_output = open_writer(output_path)
	try:
		header_line = reader.readline()
		if not header_line:
			raise ValueError("Input file is empty")

		header_fields = header_line.rstrip("\n").split("\t")
		chrom_idx = find_column_index(header_fields, ("#chr", "chr", "#Chr", "Chr"))
		pos_idx = find_column_index(header_fields, ("pos(1-based)",))
		ref_idx = find_column_index(header_fields, ("ref", "Ref"))
		alt_idx = find_column_index(header_fields, ("alt", "Alt"))
		selected_columns = [name for name in TARGET_COLUMNS if name in header_fields]
		if selected_columns != list(TARGET_COLUMNS):
			missing_columns = [name for name in TARGET_COLUMNS if name not in header_fields]
			raise ValueError(f"Missing required annotation columns: {', '.join(missing_columns)}")
		selected_indexes = [header_fields.index(name) for name in selected_columns]
		required_indexes = (chrom_idx, pos_idx, ref_idx, alt_idx, *selected_indexes)
		max_required_index = max(required_indexes)

		writer.write("\t".join((*BASE_OUTPUT_COLUMNS, *selected_columns)) + "\n")

		row_count = 0
		for line_number, line in enumerate(reader, start=2):
			fields = line.rstrip("\n").split("\t", max_required_index + 1)
			if len(fields) <= max_required_index:
				raise ValueError(
					f"Line {line_number} has fewer than {max_required_index + 1} columns"
				)

			start, end, annovar_ref, annovar_alt = annovar_coordinates(
				fields[pos_idx],
				fields[ref_idx],
				fields[alt_idx],
			)
			row = [
				"chr" +fields[chrom_idx],
				str(start),
				str(end),
				annovar_ref,
				annovar_alt,
			]
			annotation_values = [
				collapse_sift_prediction(fields[selected_indexes[0]]),
				collapse_polyphen_prediction(fields[selected_indexes[1]]),
			]
			if all(annotation_value_is_empty(value) for value in annotation_values):
				continue

			row.extend(annotation_values)
			writer.write("\t".join(row) + "\n")

			row_count += 1
			if max_rows is not None and row_count >= max_rows:
				break
			if progress_every and row_count % progress_every == 0:
				print(f"Processed {row_count:,} rows", file=sys.stderr)
	finally:
		reader.close()
		if writer is not sys.stdout:
			writer.close()

	return resolved_output, row_count, selected_columns


def main() -> int:
	args = build_argument_parser().parse_args()
	resolved_output, row_count, selected_columns = convert(
		input_path=args.input,
		output_path=args.output,
		max_rows=args.max_rows,
		progress_every=args.progress_every,
	)
	print(
		f"Wrote {row_count:,} rows with {len(selected_columns)} annotation columns to {resolved_output}",
		file=sys.stderr,
	)
	return 0


if __name__ == "__main__":
	raise SystemExit(main())

