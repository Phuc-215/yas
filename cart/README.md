# Cart service

The cart service manages customer cart items and validates product information through the product service.

Changes in this directory are validated by the `cart-ci` GitHub Actions workflow. The workflow builds and tests the cart module, reports code quality and dependency findings, and publishes the cart container image for changes merged into `main`.
