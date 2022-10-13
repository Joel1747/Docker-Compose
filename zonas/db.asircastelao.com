$TTL    36000
@       IN      SOA     ns.asircastelao.com. joel.danielcastelao.org. (
                     06102022           ; Serial
                         3600           ; Refresh [1h]
                          600           ; Retry   [10m]
                        86400           ; Expire  [1d]
                          600 )         ; Negative Cache TTL [1h]
;
@       IN      NS     ns.asircastelao.com.
ns      IN      A      10.1.0.254
test    IN      A      10.1.0.21  
alias   IN      CNAME  test      
