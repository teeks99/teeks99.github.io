---
title: Veracrypt

author: Tom Kent
category: floss-for-lent
tags: [software, floss]
# publish date
date: 2023-03-31 00:00:00 +0600

img: "/assets/img/floss/veracrypt_logo.svg"
---

Veracrypt is an encryption tool that exists in a channel completly separate from your OS vendor. It can be used to 
encrypt full hard drives or just blocks on a disk. 

On linux, you can be pretty well assured that the OS disk encryption is working well, as it can be, and has been, 
inspected by lots of people. Not so for the propriatary OS vendors. It has always been confusing to me how you can boot
most of the way into windows before you have to enter any credentials if there is good bitlocker encryption on the 
whole drive. 

Veracrypt (and its predecessor, that isn't maintained anymore, TrueCrypt) does this full disk encryption the right way. 
It just has a tiny shim on the PC that loads its decryption software, *everything* else is encrypted at rest, and you 
must have the key to access it.

*   [Veracrypt](https://www.veracrypt.fr/en/Home.html)
*   [Is TrueCrypt Audited Yet](https://istruecryptauditedyet.com/) (beware, self-signed cert...but the answer is "yes")

FLOSSing for lent 33/40