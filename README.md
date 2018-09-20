# ngx_lfqueue


Table of Contents
=================

* [Introduction](#introduction)
* [Usage](#usage)
* [Installation](#installation)
* [Test](#test)
* [Support](#support)
* [Copyright & License](#copyright--license)

Introduction
============

ngx_lfqueue is the lock free queue container running on nginx share memory and it read/write across multiple threads and multiple workers without any lock!

ngx_lfqueue is zero downtime nginx reloadable, data is on share memory, data is backupable in case nginx stop and start.


Usage
=======
### 1. Setup your lfqueue

#### There are 4 commands in this module

**_ngx_lfqueue_memory_allocate_** - main config scope (1 argument)
allocate the suitable share memory size for all the queue.

**_ngx_lfqueue_name_** - main config scope (1 argument)
init or reload the queue with a queue name, if the queue name existed on backup data, it will load from backup data.

**_ngx_lfqueue_backup_** - main config scope (2 arguments)
backup the data with special unique split key and file path, if file path not mentioned, it will stored under same directory of nginx config file.

**_ngx_lfqueue_target_** - location config scope (1 argument)
target which queue name to process data enqueue or dequeue.
_POST METHOD_ - Enqueue request body data
_GET METHOD_ - Dequeue queue message
_HEAD METHOD_ - Get the queue Info

```nginx
# nginx.conf
http {
    ngx_lfqueue_memory_allocate 10m;
    ngx_lfqueue_name q1;
    ngx_lfqueue_name q2;
    ngx_lfqueue_name q3;
    ngx_lfqueue_backup |@| /tmp/ngx_lfqueue_data.txt;	
    ...
}
```

### 2. Enqueue the message to specific queue name `ngx_lfqueue_target` by using POST/PUT method only, the request_body will be taken as queue message, response code 202
```nginx
# nginx.conf

server {
    ....
  location /processQueue {
       ngx_lfqueue_target q1;
   }


   location /processQueueWithArgVariable {
       ngx_lfqueue_target arg_targetQueue;
   }
}
```

### 3. Dequeue the message by using GET method only, response code 200
```nginx
# nginx.conf

server {
    ....
   location /processQueue {
       ngx_lfqueue_target q1;
   }
}
```


### 4. Get the queue info by using HEAD method only, response code 204, the headers response queue_size, total_enq, total_deq
```nginx
# nginx.conf

server {
    ....
   location /processQueue {
       ngx_lfqueue_target q1;
   }
}
```



Installation
============

ngx_lfqueue is depends on [lfqueue](https://github.com/Taymindis/lfqueue) , install lfqueue as .so library before install ngx_lfqueue.


```bash
wget 'http://nginx.org/download/nginx-1.13.7.tar.gz'
tar -xzvf nginx-1.13.7.tar.gz
cd nginx-1.13.7/

./configure --add-module=/path/to/ngx_lfqueue

make -j2
sudo make install
```

[Back to TOC](#table-of-contents)


Test
=====

It depends on nginx test suite libs, please refer [test-nginx](https://github.com/openresty/test-nginx) for installation.


```bash
cd /path/to/ngx_lfqueue
export PATH=/path/to/nginx-dirname:$PATH 
sudo prove t
```

[Back to TOC](#table-of-contents)

Support
=======

Please do not hesitate to contact minikawoon2017@gmail.com for any queries or development improvement.


[Back to TOC](#table-of-contents)

Copyright & License
===================

Copyright (c) 2018, Taymindis <cloudleware2015@gmail.com>

This module is licensed under the terms of the BSD license.

All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this
   list of conditions and the following disclaimer.
2. Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation
   and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

[Back to TOC](#table-of-contents)



## You may also like nginx lock free stack 

[ngx_lfstack](https://github.com/Taymindis/ngx_lfstack)
