# Backing up Linux, and your Home Directory

## OS Backups
### TimeShift

## Home Backups
### Cronopete

## Creating split Home / OS Partitions
### First, make sure your home directory is on a separate partition other than the OS:
- Use lsblk -f to find all disks
- Use KDEPartitionManager or use GParted

## Migrating the Home folder
### To migrate your current Home folder to an external partition, there are four things that you need to do:
# Mount the external partition onto a temporary Home location.
# Copy the files from your current Home folder to this temporary Home folder.
# Relocate the current Home folder
# Mount the new Home folder.

1. Create a temporary Home folder
# Open a terminal and type the following:
```
sudo blkid 
```

This will display the UID of all the partitions. Record down the UUID for the partition that you have created earlier.

Next, open the fstab file:

```
sudo nano /etc/fstab
```

and add the following line to the end of the file.

```
UUID=xxx-xxxxx-xxxxx   /mnt/home    ext4          nodev,nosuid       0       2
```

Replace the UUID with the UUID value of the external partition.

Save (Ctrl + o) and exit (ctrl + x) the file.

Next, create a mount point:

```
sudo mkdir /mnt/home
```

and reload the updated fstab.

```
sudo mount -a
```

You should now see a “home” folder in the mnt directory.

2. Copy the files from your current Home folder to the new Home folder.
The next thing we are going to do is to copy all the files from the current Home folder to the new Home folder. You can simply do a “Select all”, “Copy” and “Paste” to transfer all the files to the new Home folder. However, you might be missing out the hidden files and some of the file permissions might not be preserved. A more complete method would be using rsync.

```
sudo rsync -aXS /home/. /mnt/home/.
```

3. Relocate the current Home folder
Once we have set up the new Home folder, we need to remove the existing Home folder to make way for the new Home folder in the external partition. To do that, type the following commands in the terminal:

```
cd /
sudo mv /home /home_backup
sudo mkdir /home
```
What the above commands do is to move the existing Home folder to Home_backup, and create an empty Home folder for the new Home folder to mount to.

4. Mount the new Home folder
The last step to complete the migration is to mount the new Home folder as “/home”. To do that, we have to revisit the fstab file again.

```
sudo nano /etc/fstab
```

All you have to do is to change the “/mnt/home” to “/home”. Save and exit the file.
Lastly, reload the fstab file:

```
sudo mount -a
```

That’s it. You have now migrated your Home folder to an external partition.

5. Optional: removing the Home_backup folder

Once you are done with the migration, you can either use the old Home folder as a backup, or remove it to release the storage space. To remove it, use the command:

```
sudo rm -rf /home_backup
```
