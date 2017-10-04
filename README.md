# OwnStore (WIP - Design stage)

OwnStore is an attempt to provide a consistent abstraction
across all data storage mediums and services. These services could be anything
from local filesystem, to AWS S3, to Dropbox, etc. This gives the
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
~~~Encryption~~~~. When a service requests to store data, the data is not
stored directly, it is first encrypted with a generated key, and the
key is given back to the application. When the application then wants
to retrieve this data, it must supply the same key. The OwnStore
library will make this process transparent to application developers.
