This is kept separate from the rest of Terraform to avoid ugly race conditions when running `terraform destroy`. Apply this folder first if rebuilding infrastructure from scratch.

If trying to destory this particular piece, you'll probably have to do it manually.
