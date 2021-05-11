### About soft's version between rhel and community



RHEL version numbers don't really work that way. We will often settle on a version number for a while (sometimes the entire major release) and backport features from upstream to our package.

Just saying "RHEL has version X but I need version Y" isn't accurate. The later version may have some fix or feature which we've backported to our earlier version. We do this without changing the earlier version's programming interfaces, so all your existing software still works with the improved earlier version. This is the sort of application stability advantage you gain by using RHEL.

You can learn more about that development practice here: [After an upstream project has released a newer version of a package when will the package on a Red Hat Enterprise Linux system be updated to this version?](https://access.redhat.com/solutions/2074)

The security scan needs to specify specific concerns and not just the blind advice "get a later version number". Specific concerns are usually expressed as CVEs. You can look the CVE up on the database: https://access.redhat.com/security/security-updates/ and see if we have resolved that specific concern in one of our packages.

Here's an example of that process: [CVE-2017-1000117](https://access.redhat.com/security/cve/cve-2017-1000117) describes a security vulnerability in git. That vulnerability is fixed in upsteam versions like `2.4.6` and `2.14.1`. However, we took that fix and backported it to our `git-1.7.1` package. Now you can update the RHEL package and even though you are running an "old" version of git, you are not vulnerable to this security problem anymore.

To answer your specific questions, we have rebased OpenSSL from `1.0.1e` to `1.0.2k` in RHEL 7. We might rebase to a later version in a later RHEL 7.x release or we might not.

There are definitely criteria for backporting a fix or rebasing the package. I'm not sure of those as development of userspace packages isn't my area. I'm not sure if we provide that sort of detail about our internal practices.

Once we get out of the "Full Support phase" of the [RHEL development lifecycle](https://access.redhat.com/support/policy/updates/errata/), we generally don't rebase packages anymore



#### refer

https://access.redhat.com/discussions/3440141

