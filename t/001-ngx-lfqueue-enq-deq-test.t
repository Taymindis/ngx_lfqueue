# vi:filetype=perl

use lib '/home/booking/nginx_build/test-nginx/inc';
use lib '/home/booking/nginx_build/test-nginx/lib';
use Test::Nginx::Socket 'no_plan';


our $http_config = <<'_EOC_';
    ngx_lfqueue_memory_allocate 10m;
    ngx_lfqueue_name q1;
    ngx_lfqueue_name q2;
    ngx_lfqueue_name q3;
    ngx_lfqueue_backup "|@|" /tmp/ngx_lfqueue_data.txt;
_EOC_

no_shuffle();
run_tests();


__DATA__



=== TEST 1: enqueue q1
--- http_config eval: $::http_config
--- config
    location /processQueue {
       ngx_lfqueue_target $arg_target;
    }
--- request
POST /processQueue?target=q1
{"data":"MESSAGE1"}
--- error_code: 202
--- timeout: 3
--- response_headers
Content-Type: text/plain




=== TEST 2: enqueue q1 second time
--- http_config eval: $::http_config
--- config
    location /processQueue {
       ngx_lfqueue_target $arg_target;
    }
--- request
POST /processQueue?target=q1
{"data":"MESSAGE2"}
--- error_code: 202
--- timeout: 3
--- response_headers
Content-Type: text/plain


=== TEST 1: enqueue q2
--- http_config eval: $::http_config
--- config
    location /processQueue {
       ngx_lfqueue_target $arg_target;
    }
--- request
POST /processQueue?target=q2
{"data":"MESSAGE1"}
--- error_code: 202
--- timeout: 3
--- response_headers
Content-Type: text/plain



=== TEST 1: enqueue q3
--- http_config eval: $::http_config
--- config
    location /processQueue {
       ngx_lfqueue_target $arg_target;
    }
--- request
POST /processQueue?target=q3
{"data":"MESSAGE1"}
--- error_code: 202
--- timeout: 3
--- response_headers
Content-Type: text/plain




=== TEST 2: enqueue q3 second time
--- http_config eval: $::http_config
--- config
    location /processQueue {
       ngx_lfqueue_target $arg_target;
    }
--- request
POST /processQueue?target=q3
{"data":"MESSAGE2"}
--- error_code: 202
--- timeout: 3
--- response_headers
Content-Type: text/plain



=== TEST 5: dequeue q1
--- http_config eval: $::http_config
--- config
    location /processQueue {
       ngx_lfqueue_target $arg_target;
    }
--- request
GET /processQueue?target=q1
--- error_code: 200
--- timeout: 10
--- response_headers
Content-Type: text/plain
--- response_body_like eval chomp
qr/.*?\"MESSAGE1\".*/



=== TEST 6: dequeue q1 second time
--- http_config eval: $::http_config
--- config
    location /processQueue {
       ngx_lfqueue_target $arg_target;
    }
--- request
GET /processQueue?target=q1
--- error_code: 200
--- timeout: 10
--- response_headers
Content-Type: text/plain
--- response_body_like eval chomp
qr/.*?\"MESSAGE2\".*/



=== TEST 5: dequeue q2
--- http_config eval: $::http_config
--- config
    location /processQueue {
       ngx_lfqueue_target $arg_target;
    }
--- request
GET /processQueue?target=q2
--- error_code: 200
--- timeout: 10
--- response_headers
Content-Type: text/plain
--- response_body_like eval chomp
qr/.*?\"MESSAGE1\".*/



=== TEST 5: dequeue q3
--- http_config eval: $::http_config
--- config
    location /processQueue {
       ngx_lfqueue_target $arg_target;
    }
--- request
GET /processQueue?target=q3
--- error_code: 200
--- timeout: 10
--- response_headers
Content-Type: text/plain
--- response_body_like eval chomp
qr/.*?\"MESSAGE1\".*/



=== TEST 6: dequeue q3 second time
--- http_config eval: $::http_config
--- config
    location /processQueue {
       ngx_lfqueue_target $arg_target;
    }
--- request
GET /processQueue?target=q3
--- error_code: 200
--- timeout: 10
--- response_headers
Content-Type: text/plain
--- response_body_like eval chomp
qr/.*?\"MESSAGE2\".*/