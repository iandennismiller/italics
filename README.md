# italics

## Workflows

### Reading

- the user does a single-sign-on thing by literally signing a message from the address with the reader token
- the server can check the blockchain to verify that address A holds token T
- the server will display a list of all assets available to address A based on tokens [T] held.

### Buying

- address connects to website via Metamask
- reader clicks widget to buy token to read document
- invoke contract with purchase_token() to send funds to contract
- contract sends token to reader address
  - the address gets assigned as the holder of a specific ERC-1155 token

### Publishing

- invoke contract with list_asset(), URI, and sale amount
- create widget for URI and price

## Example

The file has the following metadata:

- name: New Insights in Blockchain Economies
- url: http://localhost:8080/QKruVYruACKhpiBEUftdRgSgkTRdP1E2GYtoeUbsCqM/report.pdf
