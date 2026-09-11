Step 1: Create a Temporary Virtual Machine (VM)

To put the uncompressed database onto a disk, you first need a blank disk attached to a temporary VM where you can download and extract it once.

1. Go to the Compute Engine VM Instances page in your GCP console.
2. Click Create Instance.
3. Configure the VM:
   - Machine Type: Choose a standard machine (e.g., e2-standard-4).
   - Boot Disk: Standard Linux (Ubuntu or Debian) is fine.
4. Expand the Advanced Options section at the bottom, go to Disks, and click Add New Disk.
5. Configure the new disk:
   - Name: starfusion-db-disk
   - Disk type: Standard Persistent Disk (HDD) is fine and cheap, or Balanced Persistent Disk for slightly faster initial setup.
   - Size: 60 GB (in ACCRE, it cost 72 GB, but in GCP, it only cost 57 GB for uncompressed database).
   - Attachment type: Read/write.
6. Click Save on the disk, and then click Create to launch the VM.

Step 2: Format, Mount, and Populate the Disk

Once the VM is running, you need to format the new blank disk, copy the uncompressed files onto that disk.

1. Next to your VM in the console, click the SSH button to open a terminal window.
2. Find your attached blank disk (such like: /dev/sda)
   ```bash
   lsblk
   ```
3. Format the disk with an ext4 file system:
   ```bash
   sudo mkfs.ext4 -m 0 -E lazy_itable_init=0,lazy_journal_init=0,discard /dev/sda
   ```
4. Create a directory and mount the disk:
   ```bash
   sudo mkdir -p /mnt/disks/star_fusion
   sudo mount -o discard,defaults /dev/sda /mnt/disks/star_fusion
   sudo chmod a+w /mnt/disks/star_fusion
   ```
5. Sync the uncompressed directory straight from your bucket to the attached disk:
   ```bash
   gcloud storage rsync -r gs://vangard-workflow-result/star_fusion/ctat_genome_lib_build_dir/ /mnt/disks/star_fusion/
   ```

Step 3: Delete the VM (Keep the Disk)

Now that the disk contains only the clean, uncompressed database files, you can shut down the VM.
1. Close the SSH window.
2. In the GCP Console, select your temporary VM and click Delete.
3. Crucial: Ensure that "Delete boot disk" is checked, but uncheck or make sure your star-fusion-db-disk is NOT set to auto-delete. You want the data disk to survive.

Step 4: Create the Snapshot

With the standalone disk sitting in your inventory, you can now create a snapshot. Snapshots act as global blueprints that Terra can use to instantly spin up identical copies.

1. In the Compute Engine left-hand menu, navigate to Storage > Snapshots.
2. Click Create Snapshot.
3. Fill out the details:
   - Name: starfusion-db-60gb-snapshot
   - Source disk: Select starfusion-db-disk (the disk you just populated).
   - Location: Choose Regional and match the exact region your Terra workspace uses (usually us-central1).
   - Snapshot type: Standard.
4. Click Create.
5. Equivalent code:
   ```bash
   gcloud compute snapshots create starfusion-db-20231029 \
       --project=vangard-workflow-data \
       --description=GRCh38_gencode_v44_CTAT_lib_Oct292023.plug-n-play \
       --source-disk=starfusion-db-disk \
       --source-disk-zone=us-central1-a \
       --storage-location=us-central1
   ```

Step 5: Delete the old disk

Because you chose a Standard Snapshot rather than an instant snapshot, Google Cloud copies all of the disk's data blocks and stores them as an entirely independent object in background cloud storage. It does not rely on the original staging disk to survive. [1] (https://docs.cloud.google.com/compute/docs/disks/snapshots), [2] (https://docs.cloud.google.com/compute/docs/disks/instant-snapshots)

Deleting the starfusion-db-disk immediately is highly recommended so you don't keep getting billed for an idle 80 GB persistent disk block sitting in your account.

Step 6: Share the snapshot with the project

This method grants the second project read-only permission to access the snapshot. 

- Go to the IAM & Admin page inside your Source Project (where the snapshot lives).
- Click Grant Access at the top. 
- Under New principals, enter the Compute Engine service account or user account from your Target Project.
  - If using it for a Terra workflow, enter your Target Project's Google Compute Service Account (looks like: pet-XXXX@terra-XXXX.iam.gserviceaccount.com).
- Under Role, select Snapshot Viewer.
- Save
