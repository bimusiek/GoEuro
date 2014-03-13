## GoEuro Resume
**Author**
[Michał Hernas](michal@hernas.pl) - [http://hern.as](http://hern.as)

# Prerequisites

    pod install

Then open ``.xcworkspace`` instead of ``.xcodeproj``

**Warning**
Because of wrong SSL Cert for API domain you need to 
add ``_AFNETWORKING_ALLOW_INVALID_SSL_CERTIFICATES_=1`` 
to ``preprocessor macros`` in Pods-GoEuro-AFHTTPNetworking.
