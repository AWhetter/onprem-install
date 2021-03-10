---
title: Okta Authentication
description:
---

CodeStream now supports Okta's consolidated single sign-on service for
authentication as well. To get it running, you'll need to set up an Okta Web
Application for CodeStream's OAuth process. Simply follow the instructions
below.

## Login to your Okta Admin Portal

Sign-in to your Okta console with an Administrator account. On the Dashboard,
select the Classic UI interface (red oval).

![Okta Admin Console](../assets/images/okta/01 Dashboard.png)


## Go to the Applications pane to Add an Application

Go to the Applications panel by clicking on **Applications** on the top nav bar
or **Add Applications** on the right nav bar (green ovals). Then press the
green **Add Application** button.

![Okta Applications](../assets/images/okta/02 Applications.png)


## Add the CodeStream Application

Type **codestream** in the search bar and select the CodeStream app.

![Okta CodeStream App](../assets/images/okta/03 Find CodeStream App.png)

Then click the green **Add** button on the CodeStream app page.

![Okta CodeStream App](../assets/images/okta/04 Add CodeStream App.png)


## Give the App a name

Give the App a name, for example **CodeStream On-Prem**, and press the
**Done** button.

![Okta Name CodeStream App](../assets/images/okta/05 Name CodeStream App.png)


## Record the App Client ID and Secret

With the new app selected, go to the **Sign-On** pane. Make note of the **Client
ID** and **Client Secret** which you will add to the CodeStream configuration
file in a later step (green circles).

Then click the **Edit** button to the right of settings (red circle).

![Okta Edit CodeStream App](../assets/images/okta/06 Sign-On Pane.png)


## Add your CodeStream API hostname

Once you've clicked **Edit**, scroll down and fill in the **HostName** property
in the _Advanced Sign-On Settings_ section.  This should be the fully qualified
public-facing host name (without any protocol scheme or other URL properties) of
your on-prem CodeStream API server.

After you've entered the host name, click the green **Save** button.

![Okta Edit CodeStream App](../assets/images/okta/07 Add API Hostname.png)


## Assign persons to the CodeStream App

Now go to the **Assignments** pane and click the green **Assign** button.

![Okta Assignments](../assets/images/okta/08 User Assignments.png)

Then add all the users and/or groups you want to allow to authenticate
CodeStream with Okta and click the green **Done** button.

![Okta Assignments](../assets/images/okta/08b User Assignments.png)


## Update your CodeStream configuration and Restart

*	Using your web browser, launch the Admin App (usually on port 8080 or 8443
	on your CodeStream On-Prem server). Login if need be.

*   Navigate to the **Configuration > Integrations** pane, open the Okta
    integration accordion and add the app data.

	<img src="../assets/images/adminapp/orig/CfgIntOkta.png" height="350" />

*	After making your edits, [follow these instructions to save your
	changes](../adminapp/#saving-and-activating-changes) and **make sure you
	activate the new configuration**.

*	Finally, [restart the services](../configs/single-host-linux/#retart-the-services).

Instruct your users to _Reload_ their IDEs. They should now be able to
authenticate with Okta.
