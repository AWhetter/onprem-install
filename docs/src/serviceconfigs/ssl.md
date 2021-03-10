---
title: SSL Certificates
description: Add an SSL Certificate for secure communication
---

Using SSL Certificates is a very good idea and now that you've tasted
CodeStream, it's time to start securing it. It's also something you'll need to
do in order to make use of our integrations.

You can use either accredited certificates (those issued from a known and
accepted Certificate Authority) or your own self-signed certificates. If you
create your own, your client IDEs will need to modify their settings to allow
self-signed certificates by disabling **strict certificate checking**.

## Obtain Your SSL Certificate

As mentioned above you can purchase one from a CA or sign your own. Obtaining
one is beyond the scope of this guide. For the **Single Host Linux**
configuratoin, a certificate for a single host name is sufficient.

When you obtain your certificate you'll have 2 or 3 files.

*	A private key which you created to sign your certificate.
*	The certificate issued by the CA or self-signed.
*   An optional _certificate chain_ or _bundle_ file which contains the root and
    intermediate issuer certificates. It's often not appicable to self-signed
    certificates.

Place a copy of the files (in **PEM** format) in the **~/.codestream/** directory
on the linux host OS.

## Add the Certificate to the Configuration

Use the **Admin App** to upload the certificate into your codestream
configuration and activate it.

*	Using your web browser, launch the admin app (usually on port 8080 on your
	CodeStream On-Prem server). Login if need be.

*	Navigate to the **Configuration > Topology** pane.

 <img src="../assets/images/adminapp/orig/CfgTopology.png" height="400" />

<br />

*	Add your TLS certificate, key & optional bundle file.

*   Next, change your ports to reflect that you're now running under HTTPS/TLS.
    We recommend you use 443 for the API, 12443 for the broadcaster and 8443 for
    the Admin App. The API has a secondary, public-facing, port which can be
    different than the port the API service actually listens on. This is to
    support installations that have proxies or load balancers in front of the
    On-Prem server. A client extension will contact the API using the public
    facing port. Normally it should match the API port.

*	Check the box which indicates you want to use secure communications.

## Save, Activate and Restart

*   After making your edits, [follow these instructions to save your
    changes](../adminapp/#saving-and-activating-changes) and **make sure you
    activate the new configuration**.

*  [Restart the On-Prem services](../configs/single-host-linux/#retart-the-services).

## Update Your CodeStream IDE Client Settings

Everyone using CodeStream will need to modify their IDE settings with the new
secure URL. Have your clients [follow the IDE-specific instructions located
here.](../ide/overview)