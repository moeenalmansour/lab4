# Reflection

After this lab, I would never build cloud resources by hand in the portal again.

First, when I changed a tag in the portal, Azure accepted it silently, and nobody noticed until I ran `terraform plan`. Then I restored it from Git through a pull request, and I saw the plan before I merged. So every change is reviewed and has a history: who changed what, and why.

Second, I destroyed everything and rebuilt it with one command in under three minutes. By hand, I would have to remember every setting and repeat it, and I would surely forget something.

Third, I would never store a cloud password in the pipeline again. OIDC gives short-lived access with no secret to leak.

I also hit real errors on the way, like the storage permission and the identity mismatch between GitHub and Azure. I fixed each one in code or in settings, and everything stayed in the Git history.
