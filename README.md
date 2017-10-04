# OwnStore (WIP - Design stage)

OwnStore provides a consistent abstraction
across all data storage mediums and services. These services can be anything,
from local filesystem, to AWS S3, to IPFS, etc. This gives the
end user complete control over their own data. A complete OwnStore
"installation" consists of a single configuration file, describing all your
data storage locations. Applications use the OwnStore library to
securely retrieve data from the services specified.

## Design Notes

End result will be a simple library, ported to various languages, for use
in any application that utilizes OwnStore.

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
