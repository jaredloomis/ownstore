# OwnStore (WIP - Design stage)

OwnStore provides a consistent abstraction
across all data storage mediums and services. These services can be anything,
from local filesystem, to AWS S3, to IPFS, etc. This gives the
*end user* complete control over their **own data**.

## Web Integration

My main goal is to ensure the web integration is optimal

Users can tell OwnStore-enabled sites to store data wherever user pleases, from
local, to IPFS, to S3, etc. The website then makes requests directly to services
(or to daemon, then to server). This will require a frontend library to allow the
use of this storage infrastructure by product developers.

## Architecture

### Possibility #1

A library is written in each target language, application developers
use the library directly.

A complete OwnStore "installation" consists of a single configuration file, describing all your
data storage locations. Applications use the OwnStore library to
securely retrieve data from the services specified.

### Possibility #2

**Server model**. OwnStore itself is a daemonized server running on *user's* computer.
This does have the downside of requiring software installation on the user's computer.

### Conclusion

Initial implementation will exist as a server for simplicity sake (in Haskell). If the server architechture
is deemed unsuitable, we already have the Haskell library, so then ports to other languages would be
the only other task.

## Conceptual Issues

### Security considerations

If you have a text file containing all your logins for all your data
services, a malicious entity has immediate access to everything. The answer?
**Encryption**. When a service requests to store data, the data is not
stored directly, it is first encrypted with a generated key, and the
key is given back to the application. When the application then wants
to retrieve this data, it must supply the same key. The OwnStore
library will make this process transparent to application developers.

### Globally-Accessible vs Local Endpoints

There should be a distinction between:

- Globally accessible endpoints
  - Endpoints that can be accessed from any machine, assuming some set of
    basic requirements such as internet connectivity
- Local endpoints
  - Local filesystem storage or a local DB obviously cannot be (directly)
    accessed from another machine, assuming no interface is exposed

Cloud services can only utilize the global endpoints, while
client applications can use both.
