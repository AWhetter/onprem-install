---
title: Issue Tracking Integrations
description: Integrate your CodeStream installation with popular issue tracking services
---

CodeStream can be integrated with a number of popular issue tracking services.
Some of them (see list below) require configuration by the CodeStream server
administrator. The pages in this section will walk you through setting up each
of the services and adding the appropriate configuration directives to your
CodeStream On-Prem installation.

* [Asana](asana)
* [Azure DevOps](azuredevops)
* [BitBucket](bitbucket)
* [GitHub](github)
* [GitLab](gitlab)
* [Trello](trello)

CodeStream also has integrations with Jira, Jira Server, GitHub Enterprise,
GitLab Self-Managed, Bitbucket Server and YouTrack (cloud service from
JetBrains), but these integrations do not require any special work from on-prem
admins. 

The Jira Server integration, however, may require involvement from a
Jira admin. If your version of Jira Server is 8.14.0 or later ([check your version](https://docs.codestream.com/userguide/faq/jira-server-version/)), end users can connect on their own using API tokens. Older versions of Jira Server will require a Jira admin to [set up a CodeStream application link](https://docs.codestream.com/userguide/faq/jira-server-integration/).