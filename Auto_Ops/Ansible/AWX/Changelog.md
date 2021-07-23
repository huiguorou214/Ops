# Changelog

> 这个changelog主要是用来整理一些我认为和我使用的过程中关系比较大一点的功能增加或者bug修复等，更多的changelog可以查看官方源地址列出来的内容



## Changes from  v13.0.0 to v19.2.2

- v19.2.1 引入不同与之前 'default' 的实例组（Instance Group）'controlplane'  (https://github.com/ansible/awx/pull/10324)
- v19.2.1 模块移除：`tower_send`, `tower_receive`, `tower_workflow_template` (https://github.com/ansible/awx/pull/9980)
- 提升了当job出现大量events时的UI性能 (https://github.com/ansible/awx/pull/10053)
- 



# Source Address

https://raw.githubusercontent.com/ansible/awx/devel/CHANGELOG.md



# 19.2.1 (June 17, 2021)

- Improved UI performance when a large amount of events are being emitted by jobs (https://github.com/ansible/awx/pull/10053)
- Settings UI Revert All button now issues a DELETE instead of PATCHing all fields (https://github.com/ansible/awx/pull/10376)
- Fixed a bug with the schedule date/time picker in Firefox (https://github.com/ansible/awx/pull/10291)
- UI now preselects the system default Galaxy credential when creating a new organization (https://github.com/ansible/awx/pull/10395)
- Added favicon (https://github.com/ansible/awx/pull/10388)
- Removed `not` option from smart inventory host filter search as it's not supported by the API (https://github.com/ansible/awx/pull/10380)
- Added button to allow user to refetch project revision after project sync has finished (https://github.com/ansible/awx/pull/10334)
- Fixed bug where extraneous CONFIG requests were made on logout (https://github.com/ansible/awx/pull/10379)
- Fixed bug where users were unable to cancel inventory syncs (https://github.com/ansible/awx/pull/10346)
- Added missing dashboard graph filters (https://github.com/ansible/awx/pull/10349)
- Added support for typing in to single select lookup form fields (https://github.com/ansible/awx/pull/10257)
- Fixed various bugs related to user sessions (https://github.com/ansible/awx/pull/9908)
- Fixed bug where sorting in modals would close the modal (https://github.com/ansible/awx/pull/10215)
- Added support for Red Hat Insights as an inventory source (https://github.com/ansible/awx/pull/8650)
- Fixed bugs when selecting items in a list then sorting/paginating (https://github.com/ansible/awx/pull/10329)

# 19.2.0 (June 1, 2021)
- Fixed race condition that would sometimes cause jobs to error out at the very end of an otherwise successful run (https://github.com/ansible/receptor/pull/328)
- Fixes bug where users were unable to click on text next to checkboxes in modals (https://github.com/ansible/awx/pull/10279)
- Have the project update playbook warn if role/collection syncing is disabled. (https://github.com/ansible/awx/pull/10068)
- Move irc references to point to irc.libera.chat (https://github.com/ansible/awx/pull/10295)
- Fixes bug where activity stream changes were displaying as [object object] (https://github.com/ansible/awx/pull/10267)
- Update awxkit to enable export of Galaxy credentials associated to organizations (https://github.com/ansible/awx/pull/10271)
- Bump receptor and receptorctl versions to 1.0.0a2 (https://github.com/ansible/awx/pull/10261)
- Add the ability to disable local authentication (https://github.com/ansible/awx/pull/10102)
- Show error if no Execution Environment is found on project sync/job run (https://github.com/ansible/awx/pull/10183)
- Allow for editing and deleting managed_by_tower EEs from API/UI (https://github.com/ansible/awx/pull/10173)


# 19.1.0 (May 1, 2021)

- Custom inventory scripts have been removed from the API https://github.com/ansible/awx/pull/9822
  - Old scripts can be exported via `awx-manage export_custom_scripts`
- Fixed a bug where ad-hoc commands targeted against multiple hosts would run against only 1 host https://github.com/ansible/awx/pull/9973
- AWX will now look for a top-level requirements.yml when installing collections / roles in project updates https://github.com/ansible/awx/pull/9945
- Improved error handling when Container Group pods fail to launch https://github.com/ansible/awx/pull/10025
- Added ability to set server-side password policies using Django's AUTH_PASSWORD_VALIDATORS setting https://github.com/ansible/awx/pull/9999
- Bumped versions of Ansible Runner & AWX EE https://github.com/ansible/awx/pull/10013
  - If you have built any custom EEs on top of awx-ee 0.1.0, you will need to rebuild on top of 0.2.0.
- Remove legacy resource profiling code https://github.com/ansible/awx/pull/9883

# 19.0.0 (April 7, 2021)

- AWX now runs on Python 3.8 (https://github.com/ansible/awx/pull/8778/)
- Fixed inventories-from-projects when running in Kubernetes (https://github.com/ansible/awx/pull/9741)
- Fixed a bug where a slash was appended to invetory file paths in UI dropdown (https://github.com/ansible/awx/pull/9713)
- Fix a bug with large file parsing in project sync (https://github.com/ansible/awx/pull/9627)
- Fix k8s credentials that use a custom ca cert (https://github.com/ansible/awx/pull/9744)
- Fix a bug that allowed a user to attempt deleting a running job (https://github.com/ansible/awx/pull/9758)
- Fixed the Kubernetes Pod reaper to properly delete Pods launched by Receptor (https://github.com/ansible/awx/pull/9819)
- AWX Collection Modules: added ability to set instance groups for organization, job templates, and inventories. (https://github.com/ansible/awx/pull/9804)
- Fixed CSP violation errors on job details and job settings views (https://github.com/ansible/awx/pull/9818)
- Added support for convergence any/all on workflow nodes (https://github.com/ansible/awx/pull/9737)
- Fixed race condition that causes InvalidGitRepositoryError (https://github.com/ansible/awx/pull/9754)
- Added support for Execution Environments to the Activity Stream (https://github.com/ansible/awx/issues/9308)
- Fixed a bug that improperly formats OpenSSH keys specified in custom Credential Types (https://github.com/ansible/awx/issues/9361)
- Fixed an HTTP 500 error for unauthenticated users (https://github.com/ansible/awx/pull/9725)
- Added subscription wizard: https://github.com/ansible/awx/pull/9496

# 18.0.0 (March 23, 2021)

**IMPORTANT INSTALL AND UPGRADE NOTES**

Starting in version 18.0, the [AWX Operator](https://github.com/ansible/awx-operator) is the preferred way to install AWX: https://github.com/ansible/awx/blob/devel/INSTALL.md#installing-awx

If you have a pre-existing installation of AWX that utilizes the Docker-based installation method, this install method has ** notably changed** from 17.x to 18.x.  For details, please see:

- https://groups.google.com/g/awx-project/c/47MjWSUQaOc/m/bCjSDn0eBQAJ
- https://github.com/ansible/awx/blob/devel/tools/docker-compose
- https://github.com/ansible/awx/blob/devel/tools/docker-compose/docs/data_migration.md

### Introducing Execution Environments

After a herculean effort from a number of contributors, we're excited to announce that AWX 18.0.0 introduces a new concept called Execution Environments.

Execution Environments are container images which consist of everything necessary to run a playbook within AWX, and which drive the entire management and lifecycle of playbook execution runtime in AWX: https://github.com/ansible/awx/issues/5157.  This means that going forward, AWX no longer utilizes the [bubblewrap](https://github.com/containers/bubblewrap) project for playbook isolation, but instead utilizes a container per playbook run.

Much like custom virtualenvs, custom Execution Environments can be crafted to specify additional Python or system-level dependencies.  [Ansible Builder](https://github.com/ansible/ansible-builder) outputs images you can upload to your registry which can *then* be defined in AWX and utilized for playbook runs.

To learn more about Ansible Builder and Execution Environments, see: https://www.ansible.com/blog/introduction-to-ansible-builder

### Other Notable Changes

- Removed `installer` directory.
  - The Kubernetes installer has been removed in favor of [AWX Operator](https://github.com/ansible/awx-operator).  Official images for Operator-based installs are no longer hosted on Docker Hub, but are instead available on [Quay](https://quay.io/repository/ansible/awx?tab=tags).
  - The "Local Docker" install method has been removed in favor of the development environment. Details can be found at: https://github.com/ansible/awx/blob/devel/tools/docker-compose/README.md
- Removal of custom virtual environments https://github.com/ansible/awx/pull/9498
  - Custom virtual environments have been replaced by Execution Environments https://github.com/ansible/awx/pull/9570
- The default Container Group Pod definition has changed. All custom Pod specs have been reset. https://github.com/ansible/awx/commit/05ef51f710dad8f8036bc5acee4097db4adc0d71
- Added user interface for the activity stream: https://github.com/ansible/awx/pull/9083
- Converted many of the top-level list views (Jobs, Teams, Hosts, Inventories, Projects, and more) to a new, permanent table component for substantially increased responsiveness, usability, maintainability, and other 'ility's: https://github.com/ansible/awx/pull/8970, https://github.com/ansible/awx/pull/9182 and many others!
- Added support for Centrify Vault (https://www.centrify.com) as a credential lookup plugin (https://github.com/ansible/awx/pull/9542)
- Added support for namespaces in Hashicorp Vault credential plugin (https://github.com/ansible/awx/pull/9590)
- Added click-to-expand details for job tables
- Added search filtering to job output https://github.com/ansible/awx/pull/9208
- Added the new migration, update, and "installation in progress" page https://github.com/ansible/awx/pull/9123
- Added the user interface for job settings https://github.com/ansible/awx/pull/8661
- Runtime errors from jobs are now displayed, along with an explanation for what went wrong, on the output page https://github.com/ansible/awx/pull/8726
- You can now cancel a running job from its output and details panel https://github.com/ansible/awx/pull/9199
- Fixed a bug where launch prompt inputs were unexpectedly deposited in the url: https://github.com/ansible/awx/pull/9231
- Playbook, credential type, and inventory file inputs now support type-ahead and manual type-in! https://github.com/ansible/awx/pull/9120
- Added ability to relaunch against failed hosts: https://github.com/ansible/awx/pull/9225
- Added pending workflow approval count to the application header https://github.com/ansible/awx/pull/9334
- Added user interface for management jobs: https://github.com/ansible/awx/pull/9224
- Added toast message to show notification template test result to notification templates list https://github.com/ansible/awx/pull/9318
- Replaced CodeMirror with AceEditor for editing template variables and notification templates https://github.com/ansible/awx/pull/9281
- Added support for filtering and pagination on job output https://github.com/ansible/awx/pull/9208
- Added support for html in custom login text https://github.com/ansible/awx/pull/9519

# 17.1.0 (March 9, 2021)
- Addressed a security issue in AWX (CVE-2021-20253)
- Fixed a bug permissions error related to redis in K8S-based deployments: https://github.com/ansible/awx/issues/9401

# 17.0.1 (January 26, 2021)
- Fixed pgdocker directory permissions issue with Local Docker installer: https://github.com/ansible/awx/pull/9152
- Fixed a bug in the UI which caused toggle settings to not be changed when clicked: https://github.com/ansible/awx/pull/9093

# 17.0.0 (January 22, 2021)
- AWX now requires PostgreSQL 12 by default: https://github.com/ansible/awx/pull/8943
  **Note:** users who encounter permissions errors at upgrade time should `chown -R ~/.awx/pgdocker` to ensure it's owned by the user running the install playbook
- Added support for region name for OpenStack inventory: https://github.com/ansible/awx/issues/5080
- Added the ability to chain undefined attributes in custom notification templates: https://github.com/ansible/awx/issues/8677
- Dramatically simplified the `image_build` role: https://github.com/ansible/awx/pull/8980
- Fixed a bug which can cause schema migrations to fail at install time: https://github.com/ansible/awx/issues/9077
- Fixed a bug which caused the `is_superuser` user property to be out of date in certain circumstances: https://github.com/ansible/awx/pull/8833
- Fixed a bug which sometimes results in race conditions on setting access: https://github.com/ansible/awx/pull/8580
- Fixed a bug which sometimes causes an unexpected delay in stdout for some playbooks: https://github.com/ansible/awx/issues/9085
- (UI) Added support for credential password prompting on job launch: https://github.com/ansible/awx/pull/9028
- (UI) Added the ability to configure LDAP settings in the UI: https://github.com/ansible/awx/issues/8291
- (UI) Added a sync button to the Project detail view: https://github.com/ansible/awx/issues/8847
- (UI) Added a form for configuring Google Outh 2.0 settings: https://github.com/ansible/awx/pull/8762
- (UI) Added searchable keys and related keys to the Credentials list: https://github.com/ansible/awx/issues/8603
- (UI) Added support for advanced search and copying to Notification Templates: https://github.com/ansible/awx/issues/7879
- (UI) Added support for prompting on workflow nodes: https://github.com/ansible/awx/issues/5913
- (UI) Added support for session timeouts: https://github.com/ansible/awx/pull/8250
- (UI) Fixed a bug that broke websocket streaming for the insecure ws:// protocol: https://github.com/ansible/awx/pull/8877
- (UI) Fixed a bug in the user interface when a translation for the browser's preferred locale isn't available: https://github.com/ansible/awx/issues/8884
- (UI) Fixed bug where navigating from one survey question form directly to another wasn't reloading the form: https://github.com/ansible/awx/issues/7522
- (UI) Fixed a bug which can cause an uncaught error while launching a Job Template: https://github.com/ansible/awx/issues/8936
- Updated autobahn to address CVE-2020-35678

## 16.0.0 (December 10, 2020)
- AWX now ships with a reimagined user interface.  **Please read this before upgrading:** https://groups.google.com/g/awx-project/c/KuT5Ao92HWo
- Removed support for syncing inventory from Red Hat CloudForms - https://github.com/ansible/awx/commit/0b701b3b2
- Removed support for Mercurial-based project updates - https://github.com/ansible/awx/issues/7932
- Upgraded NodeJS to actively maintained LTS 14.15.1 - https://github.com/ansible/awx/pull/8766
- Added Git-LFS to the default image build - https://github.com/ansible/awx/pull/8700
- Added the ability to specify `metadata.labels` in the podspec for container groups - https://github.com/ansible/awx/issues/8486
- Added support for Kubernetes pod annotations - https://github.com/ansible/awx/pull/8434
- Added the ability to label the web container in local Docker installs - https://github.com/ansible/awx/pull/8449
- Added additional metadata (as an extra var) to playbook runs to report the SCM branch name - https://github.com/ansible/awx/pull/8433
- Fixed a bug that caused k8s installations to fail due to an incorrect Helm repo - https://github.com/ansible/awx/issues/8715
- Fixed a bug that prevented certain Workflow Approval resources from being deleted - https://github.com/ansible/awx/pull/8612
- Fixed a bug that prevented the deletion of inventories stuck in "pending deletion" state - https://github.com/ansible/awx/issues/8525
- Fixed a display bug in webhook notifications with certain unicode characters - https://github.com/ansible/awx/issues/7400
- Improved support for exporting dependent objects (Inventory Hosts and Groups) in the `awx export` CLI tool - https://github.com/ansible/awx/commit/607bc0788

## 15.0.1 (October 20, 2020)
- Added several optimizations to improve performance for a variety of high-load simultaneous job launch use cases https://github.com/ansible/awx/pull/8403
- Added the ability to source roles and collections from requirements.yaml files (not just requirements.yml) - https://github.com/ansible/awx/issues/4540
- awx.awx collection modules now provide a clearer error message for incompatible versions of awxkit - https://github.com/ansible/awx/issues/8127
- Fixed a bug in notification messages that contain certain unicode characters - https://github.com/ansible/awx/issues/7400
- Fixed a bug that prevents the deletion of Workflow Approval records - https://github.com/ansible/awx/issues/8305
- Fixed a bug that broke the selection of webhook credentials - https://github.com/ansible/awx/issues/7892
- Fixed a bug which can cause confusing behavior for social auth logins across distinct browser tabs - https://github.com/ansible/awx/issues/8154
- Fixed several bugs in the output of Workflow Job Templates using the `awx export` tool - https://github.com/ansible/awx/issues/7798 https://github.com/ansible/awx/pull/7847
- Fixed a race condition that can lead to missing hosts when running parallel inventory syncs - https://github.com/ansible/awx/issues/5571
- Fixed an HTTP 500 error when certain LDAP group parameters aren't properly set - https://github.com/ansible/awx/issues/7622
- Updated a few dependencies in response to several CVEs:
    * CVE-2020-7720
    * CVE-2020-7743
    * CVE-2020-7676

## 15.0.0 (September 30, 2020)
- Added improved support for fetching Ansible collections from private Galaxy content sources (such as https://github.com/ansible/galaxy_ng) - https://github.com/ansible/awx/issues/7813
  **Note:** as part of this change, new Organizations created in the AWX API will _no longer_ automatically synchronize roles and collections from galaxy.ansible.com by default.  More details on this change can be found at:  https://github.com/ansible/awx/issues/8341#issuecomment-707310633
- AWX now utilizes a version of certifi that auto-discovers certificates in the system certificate store - https://github.com/ansible/awx/pull/8242
- Added support for arbitrary custom inventory plugin configuration: https://github.com/ansible/awx/issues/5150
- Added an optional setting to disable the auto-creation of organizations and teams on successful SAML login. - https://github.com/ansible/awx/pull/8069
- Added a number of optimizations to AWX's callback receiver to improve the speed of stdout processing for simultaneous playbooks runs - https://github.com/ansible/awx/pull/8193 https://github.com/ansible/awx/pull/8191
- Added the ability to use `!include` and `!import` constructors when constructing YAML for use with the AWX CLI - https://github.com/ansible/awx/issues/8135
- Fixed a bug that prevented certain users from being able to edit approval nodes in Workflows - https://github.com/ansible/awx/pull/8253
- Fixed a bug that broke password prompting for credentials in certain cases - https://github.com/ansible/awx/issues/8202
- Fixed a bug which can cause PostgreSQL deadlocks when running many parallel playbooks against large shared inventories - https://github.com/ansible/awx/issues/8145
- Fixed a bug which can cause delays in AWX's task manager when large numbers of simultaneous jobs are scheduled - https://github.com/ansible/awx/issues/7655
- Fixed a bug which can cause certain scheduled jobs - those that run every X minute(s) or hour(s) - to fail to run at the proper time - https://github.com/ansible/awx/issues/8071
- Fixed a performance issue for playbooks that store large amounts of data using the `set_stats` module - https://github.com/ansible/awx/issues/8006
- Fixed a bug related to AWX's handling of the auth_path argument for the HashiVault KeyValue credential plugin - https://github.com/ansible/awx/pull/7991
- Fixed a bug that broke support for Remote Archive SCM Type project syncs on platforms that utilize Python2 - https://github.com/ansible/awx/pull/8057
- Updated to the latest version of Django Rest Framework to address CVE-2020-25626
- Updated to the latest version of Django to address CVE-2020-24583 and CVE-2020-24584
- Updated to the latest verson of channels_redis to address a bug that slowly causes Daphne processes to leak memory over time - https://github.com/django/channels_redis/issues/212

## 14.1.0 (Aug 25, 2020)
- AWX images can now be built on ARM64 - https://github.com/ansible/awx/pull/7607
- Added the Remote Archive SCM Type to support using immutable artifacts and releases (such as tarballs and zip files) as projects - https://github.com/ansible/awx/issues/7954
- Deprecated official support for Mercurial-based project updates - https://github.com/ansible/awx/issues/7932
- Added resource import/export support to the official AWX collection - https://github.com/ansible/awx/issues/7329
- Added the ability to import YAML-based resources (instead of just JSON) when using the AWX CLI - https://github.com/ansible/awx/pull/7808
- Users upgrading from older versions of AWX may encounter an issue that causes their postgres container to restart in a loop (https://github.com/ansible/awx/issues/7854) - if you encounter this, bring your containers down and then back up (e.g., `docker-compose down && docker-compose up -d`) after upgrading to 14.1.0.
- Updated the AWX CLI to export labels associated with Workflow Job Templates - https://github.com/ansible/awx/pull/7847
- Updated to the latest python-ldap to address a bug - https://github.com/ansible/awx/issues/7868
- Upgraded git-python to fix a bug that caused workflows to sometimes fail - https://github.com/ansible/awx/issues/6119
- Worked around a bug in the channels_redis library that slowly causes Daphne processes to leak memory over time - https://github.com/django/channels_redis/issues/212
- Fixed a bug in the AWX CLI that prevented Workflow nodes from importing properly - https://github.com/ansible/awx/issues/7793
- Fixed a bug in the awx.awx collection release process that templated the wrong version - https://github.com/ansible/awx/issues/7870
- Fixed a bug that caused errors rendering stdout that contained UTF-16 surrogate pairs - https://github.com/ansible/awx/pull/7918

## 14.0.0 (Aug 6, 2020)
- As part of our commitment to inclusivity in open source, we recently took some time to audit AWX's source code and user interface and replace certain terminology with more inclusive language.  Strictly speaking, this isn't a bug or a feature, but we think it's important and worth calling attention to:
    * https://github.com/ansible/awx/commit/78229f58715fbfbf88177e54031f532543b57acc
    * https://www.redhat.com/en/blog/making-open-source-more-inclusive-eradicating-problematic-language
- Installing roles and collections via requirements.yml as part of Project Updates now requires at least Ansible 2.9 - https://github.com/ansible/awx/issues/7769
- Deprecated the use of the `PRIMARY_GALAXY_USERNAME` and `PRIMARY_GALAXY_PASSWORD` settings. We recommend using tokens to access Galaxy or Automation Hub.
- Added local caching for downloaded roles and collections so they are not re-downloaded on nodes where they are up to date with the project - https://github.com/ansible/awx/issues/5518
- Added the ability to associate K8S/OpenShift credentials to Job Template for playbook interaction with the `community.kubernetes` collection - https://github.com/ansible/awx/issues/5735
- Added the ability to include HTML in the Custom Login Info presented on the login page - https://github.com/ansible/awx/issues/7600
- Fixed https://access.redhat.com/security/cve/cve-2020-14327 - Server-side request forgery on credentials
- Fixed https://access.redhat.com/security/cve/cve-2020-14328 - Server-side request forgery on webhooks
- Fixed https://access.redhat.com/security/cve/cve-2020-14329 - Sensitive data exposure on labels
- Fixed https://access.redhat.com/security/cve/cve-2020-14337 - Named URLs allow for testing the presence or absence of objects
- Fixed a number of bugs in the user interface related to an upgrade of jQuery:
     * https://github.com/ansible/awx/issues/7530
     * https://github.com/ansible/awx/issues/7546
     * https://github.com/ansible/awx/issues/7534
     * https://github.com/ansible/awx/issues/7606
- Fixed a bug that caused the `-f yaml` flag of the AWX CLI to not print properly formatted YAML - https://github.com/ansible/awx/issues/7795
- Fixed a bug in the installer that caused errors when `docker_registry_password` was set - https://github.com/ansible/awx/issues/7695
- Fixed a permissions error that prevented certain users from starting AWX services - https://github.com/ansible/awx/issues/7545
- Fixed a bug that allows superusers to run unsafe Jinja code when defining custom Credential Types - https://github.com/ansible/awx/pull/7584/
- Fixed a bug that prevented users from creating (or editing) custom Credential Types containing boolean fields - https://github.com/ansible/awx/issues/7483
- Fixed a bug that prevented users with postgres usernames containing uppercase letters from restoring backups succesfully - https://github.com/ansible/awx/pull/7519
- Fixed a bug which allowed the creation (in the Tower API) of Groups and Hosts with the same name - https://github.com/ansible/awx/issues/4680

## 13.0.0 (Jun 23, 2020)
- Added import and export commands to the official AWX CLI, replacing send and receive from the old tower-cli (https://github.com/ansible/awx/pull/6125).
- Removed scripts as a means of running inventory updates of built-in types (https://github.com/ansible/awx/pull/6911)
- Ansible 2.8 is now partially unsupported; some inventory source types are known to no longer work.
- Fixed an issue where the vmware inventory source ssl_verify source variable was not recognized (https://github.com/ansible/awx/pull/7360)
- Fixed a bug that caused redis' listen socket to have too-permissive file permissions (https://github.com/ansible/awx/pull/7317)
- Fixed a bug that caused rsyslogd's configuration file to have world-readable file permissions, potentially leaking secrets (CVE-2020-10782)

## 12.0.0 (Jun 9, 2020)
- Removed memcached as a dependency of AWX (https://github.com/ansible/awx/pull/7240)
- Moved to a single container image build instead of separate awx_web and awx_task images. The container image is just `awx` (https://github.com/ansible/awx/pull/7228)
- Official AWX container image builds now use a two-stage container build process that notably reduces the size of our published images (https://github.com/ansible/awx/pull/7017)
- Removed support for HipChat notifications ([EoL announcement](https://www.atlassian.com/partnerships/slack/faq#faq-98b17ca3-247f-423b-9a78-70a91681eff0)); all previously-created HipChat notification templates will be deleted due to this removal.
- Fixed a bug which broke AWX installations with oc version 4.3 (https://github.com/ansible/awx/pull/6948/)
- Fixed a performance issue that caused notable delay of stdout processing for playbooks run against large numbers of hosts (https://github.com/ansible/awx/issues/6991)
- Fixed a bug that caused CyberArk AIM credential plugin looks to hang forever in some environments (https://github.com/ansible/awx/issues/6986)
- Fixed a bug that caused ANY/ALL converage settings not to properly save when editing approval nodes in the UI (https://github.com/ansible/awx/issues/6998)
- Fixed a bug that broke support for the satellite6_group_prefix source variable (https://github.com/ansible/awx/issues/7031)
- Fixed a bug that prevented changes to workflow node convergence settings when approval nodes were in use (https://github.com/ansible/awx/issues/7063)
- Fixed a bug that caused notifications to fail on newer version of Mattermost (https://github.com/ansible/awx/issues/7264)
- Fixed a bug (by upgrading to 0.8.1 of the foreman collection) that prevented host_filters from working properly with Foreman-based inventory (https://github.com/ansible/awx/issues/7225)
- Fixed a bug that prevented the usage of the Conjur credential plugin with secrets that contain spaces (https://github.com/ansible/awx/issues/7191)
- Fixed a bug in awx-manage run_wsbroadcast --status in kubernetes (https://github.com/ansible/awx/pull/7009)
- Fixed a bug that broke notification toggles for system jobs in the UI (https://github.com/ansible/awx/pull/7042)
- Fixed a bug that broke local pip installs of awxkit (https://github.com/ansible/awx/issues/7107)
- Fixed a bug that prevented PagerDuty notifications from sending for workflow job template approvals (https://github.com/ansible/awx/issues/7094)
- Fixed a bug that broke external log aggregation support for URL paths that include the = character (such as the tokens for SumoLogic) (https://github.com/ansible/awx/issues/7139)
- Fixed a bug that prevented organization admins from removing labels from workflow job templates (https://github.com/ansible/awx/pull/7143)