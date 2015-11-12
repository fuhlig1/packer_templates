#!/bin/bash

echo 'Defaults:fairroot !requiretty' > /etc/sudoers.d/fairroot;      \
echo 'fairroot ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers.d/fairroot;  \
chmod 440 /etc/sudoers.d/fairroot
                        