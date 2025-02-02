# Change Log

## [8.2.26] - 2021-4-30

### Fixed 

- Addresses [#525](https://github.com/TeamCodeStream/CodeStream/issues/525) &mdash; Error creating a codemark in a file with a lot of uncommitted changes

## [8.2.25] - 2021-4-28

### Fixed 

- Fixes an issue with the broadcaster connection
- Fixes an issue with large change sets in a feedback request not being saved to the database

### Changed

- Improved copy in ivitations triggered by a proactive review of someone else's commit

## [8.2.24] - 2021-4-22

### Changed

- Backend work to support team switching when you click on a permalink for an item owned by a team other than the one you currently have selected

### Fixed 

- Fixes an issue where the issue you select via Start Work in one team, also appears in the Work In Progress section for all of your teams
- Fixes an issue with "undefined" appearing in some notification emails
- Fixes an issue with weekly activity emails going out when there was no activity

## [8.2.23] - 2021-4-6

### Changed

- Eliminates check for username uniqueness at registration since it's really a display name
- Improves logic for determining on-prem vs cloud

### Fixed

- Fixes a memory leak issue with feedback request reminder emails

## [8.2.22] - 2021-3-17

### Added

- Add backend support for displaying unread message indicators (i.e., blue badges) in the various section of the CodeStream pane

## [8.2.21] - 2021-3-12

### Added

- Updates for CMS support for weekly emails (github pages)

## [8.2.20] - 2021-3-9

### Added

- Adds backend support for prompting you to review a teammate's commits when you pull

## [8.2.19] - 2021-3-7

### Added

- Adds a new Admin service that provides onprem admins a tool for managing the configuration
- Adds a new weekly email covering you and your team's activity

## [8.2.18] - 2021-2-17

### Added

- Backend support for updating codemark or feedback request resolution status on Slack

## [8.2.17] - 2021-2-10

### Fixed

- Fixes an issue preventing Jira cloud from being listed on the Integrations page for on-prem customers

## [8.2.16] - 2021-2-9

### Added

- Security improvements

## [8.2.15] - 2021-2-2

### Added

- Adds a new one-time email/toast notification when you have an open feedback request assigned to you that hasn't had activity in 24 hours
- Adds new reminder invitations for teammates that haven't yet joined CodeStream

## [8.2.14] - 2021-1-26

### Added

- Additional changes to support the GitLens integration

## [8.2.13] - 2021-1-25

### Added

- Backend support for deeper GitLens integration

### Changed

- Changed subject of invitation email

## [8.2.12] - 2021-1-19

### Fixed

- Minor bug fixes and improvements

## [8.2.11] - 2021-1-13

### Fixed

- Fixes [#41](https://github.com/TeamCodeStream/codestream-server/issues/41) &mdash; Cannot send email using generic STMP

## [8.2.10] - 2021-1-8

### Added

- Adds backend support for the new integration with Linear

## [8.2.9] - 2020-12-22

### Changed

- Update to use V2 OAuth 2.0 flow for Slack authentication

## [8.2.8] - 2020-12-17

### Changed

- Update to repo-matching logic for new repo-based joining feature

## [8.2.7] - 2020-12-17

### Added

- Adds backend support for people joining teams based on repository access
- Adds backend support for admins restricting available integrations and authentication options

## [8.2.6] - 2020-11-24

### Changed

- Backout change to Slack OAuth v2.

## [8.2.5] - 2020-11-24

### Added

- Adds backend support for the new Clubhouse integration

### Changed

- Migrate to Slack OAuth v2.

### Fixed

- Fixes an issue where buttons to sign in with GitLab and Bitbucket were missing from the web login form

## [8.2.4] - 2020-11-13

### Changed

- Backend work to make the "Work in Progress" section of the CodeStream pane more performant, with reduced api requests

## [8.2.3] - 2020-11-5

### Added

- Adds backend support for new GitHub authentication flow in VS Code
- Adds the ability to add, edit or remove ranges when editing a comment or issue

### Fixed

- Fixes an issue where the confirmation email wasn't being sent when a user changes their email address

## [8.2.2] - 2020-9-29

### Fixed

- OnPrem quickstart configuration not loading properly

## [8.2.1] - 2020-9-16

### Changed

- Adds new `notifications` scope to the GitHub Enterprise instructions to accomodate the pull-request integration
- Enforces minimum required and suggested versions of the CodeStream extension

## [8.2.0] - 2020-8-3

### Added

- Adds support for authenticating with GitLab or Bitbucket
- Adds backend support for non-admin team members to map their Git email address to their CodeStream email address

## [8.1.0] - 2020-7-21

### Added

- Adds support for self-serve payments when subscribing to CodeStream, although not yet available for on-prem

## [8.0.0] - 2020-6-30

### Added

- Adds the ability to "start work" by selecting a ticket (Trello, Jira, etc.), moving it to the appropriate in-progress state, and automatically creating a feature branch
- Adds support for creating PRs on GitHub, GitLab or Bitbucket once a code review has been approved

## [7.4.0] - 2020-6-15

### Added

- Nightly phone-home for CodeStream On-Prem
- Assign code reviews or mention people in codemarks that aren't yet on your CodeStream team
- Broadcaster health check for load balancer configurations

## [7.2.5] - 2020-5-28

### Added

- Support for On-Prem versioning
