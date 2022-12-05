FROM alpine:3.16

# 这个 image 不主动接受参数
# 它会判断当前上下文是否在一个可交互的 terminal 里
# 如果可交互，则会将主进程交给 /bin/bash
# 否则，会 while true 下去
# 目的：可以把它当做 Pod 直接投入一个 K8s 集群，接着可以通过 exec 连接上去做一些开发工作
RUN apk add --update-cache --no-cache bash curl gomplate jq yq \
 && echo -e '#!/bin/bash\n\nif [[ -t 0 ]];\nthen exec /bin/bash\nelse while true; do sleep 600; done\nfi\n' > /usr/local/bin/xenter \
 && chmod +x /usr/local/bin/xenter

ENTRYPOINT ["/usr/local/bin/xenter"]

