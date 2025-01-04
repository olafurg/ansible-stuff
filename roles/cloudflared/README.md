# Cloudflared

Using the free version of Cloudflare Gateway to configure access policies on the network. With Pi-hole using Cloudflare Gateway as the upstream DNS provider.

Main instructions here:
https://docs.pi-hole.net/guides/dns/cloudflared/

_Note that using this on a UniFi network, it's important to disable any content filtering on that device, since it seems that bypasses the upstream CGW filtering._

* To check if a Cloudflare Gateway policy is working: https://developers.cloudflare.com/cloudflare-one/policies/filtering/dns-policies/check-policy/

* Cloudflare Radar, to look up categorization of a specific website, and suggest changes: https://radar.cloudflare.com/categorization-feedback/