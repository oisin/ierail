## Irish Rail API Ruby Wrapper

I wrote most of this on the train, as is appropriate. 

It's a trivial wrapper for the Irish Rail real time (whut?) train times system, in Ruby. It uses the HTTP GET API that was thankfully supplied along with the more *interesting* SOAP API, so a tiddly simple set up with [RestClient](https://github.com/archiloque/rest-client) and [Nokogiri](http://nokogiri.org/) (two of my favourite things ever) to pull and process the XML data into Hashes for great value.

Check the **main.rb** for sample usage.

Pull requests welcome, because there's damn all in it at the moment.

### Testing

Yes, yes indeed.