---
title: Duplicity with Azure

author: Tom Kent
category: general
tags: [media]
# publish date
date: 2024-12-28 20:00:00 +0600

---

For those who haven't heard of it before, there is a great backup tool called
[Duplicity](https://duplicity.gitlab.io/). This is a complete TNO (Trust No One)
solution for backups from a linux/unix system. It uses extremely strong 
encryption on the client side to encrypt the files you want to backup, then 
lets you upload it to dozens of different hosting services (e.g. Amazon Web 
Service's (AWS) S3, Backblaze, Google Drive, Dropbox, or even a WebDAV server
... or many more). It can do all the fancy things, incremental backups,
snapshots in time, single file retreival, etc. They've thought of it all!

Many years ago I uploaded a few GBs of backups to AWS S3 storage using 
duplicity.Ever since, I've been paying $1.42 per month to keep that backup 
there, just in case my other (quad-redundant, plus offline) backups all failed, 
I'd still have some of my most important things. It was kindof annoying, and I 
wanted to get it up to date with my current files. Plus, I've moved to mostly
using Microsoft Azure for personal stuff instead of AWS.

This post will detail how I got it working there. 


Azure Setup
-----------

Before uploading anything to Microsoft Azure, a "Storage Account" is needed to
use [Azure Blob Storage](https://learn.microsoft.com/en-us/azure/storage/blobs/storage-blobs-introduction). 
Account is a bit of a misnomer here, as it is within your existing Azure 
account. However, storage accounts *do* get tied to their own DNS setting 
(e.g. myaccount.blob.core.windows.net), so it has those rules you need to 
follow for the name. Create this in the Azure 
[portal](https://portal.azure.com), and set the 
"[redundancy](https://learn.microsoft.com/en-us/azure/storage/common/storage-redundancy)"
you desire, I did "Local Redundant Storage" (LRS), which is cheapest and has
three copies of the data in the same data center. 

Once created, you need to copy down the data needed to access it. Through the 
azure portal, browse to the storage account, then the "Access Keys" under that. 
From here, you will shortly need the whole "Connection String" (which contains
the Key as well as other important data).

Backup Script
-------------

With duplicity installed on your system and the "Connection String" to the azure
account in hand, you can make a script that will perform the backup.


```bash
#!/bin/bash

# Make your own secure passphrase
export PASSPHRASE=MAKE_A_LONG_STRING_OF_STUFF_HERE!
# You can have the passphrase in the file, but I'd recommend a separate file 
# instead, that can have strict permissions on it
source ~/.securedir/duplicity-passphrase.bash

# Copied from the azure portal, put everything you copy inside the quotes 
export AZURE_CONNECTION_STRING="DefaultEndpointsProtocol=https;AccountName=storageaccountwillbehere;AccountKey=longkeywillbehere;EndpointSuffix=core.windows.net"

# The command that will run for each backup. Pick the tier from "Hot" (default)
# "Cool" (slightly cheaper), or "Archive" (cheapest by far, but very slow to 
# access. I haven't tested, but suspect it might not work correctly)
CMD="duplicity --verbosity info --azure-blob-tier Cool"

# For each directory you want to backup, run the command with the directory and 
# the azure container

$CMD /mnt/fs/Documents azure://duplicity-documents
$CMD /mnt/fs/Pictures azure://duplicity-pictures
```

Now just setup that script to run with cron each night, and you should be good
to go!

Mixed Tiers
-----------

Ideally, duplicity would store the data from the backups (which is immutable), 
in one of the cheaper tiers (Cold, Archive) while keeping the meta data more 
readily accessible (Hot or Cool, maybe Cold). I've 
[submitted an issue to duplicity](https://gitlab.com/duplicity/duplicity/-/issues/852)
to add this feature, but until then, I'm trying it by hand. Once the volumes are
uploaded, I'm manually setting them to "Cold" while leaving the larger metadata
alone. Not great for a backup system, but I'm expecting the majority to be 
uploaded the first day, then only small increments after that, so maybe doable? 