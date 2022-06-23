// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

// require ('payments')

const appId = gon.appId;
    const locationId = gon.locationId;
async function initializeCard(payments) {
        const card = await payments.card();
        const wrapper = document.querySelector("div.sq-card-wrapper")
        if(wrapper === null) {

          await card.attach('div#card-container');
          return card;
        }

      }

      async function createPayment(token, event) {
        console.log(event)
        const body = JSON.stringify({
          locationId,
          sourceId: token,
          id: event.target.form.dataset.id
        });

        const paymentResponse = await fetch('/payment', {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
          },
          body,
        });

        if (paymentResponse.ok) {
          return paymentResponse.json();
        }

        const errorBody = await paymentResponse.text();
        throw new Error(errorBody);
      }

      async function tokenize(paymentMethod) {
        const tokenResult = await paymentMethod.tokenize();
        if (tokenResult.status === 'OK') {
          return tokenResult.token;
        } else {
          let errorMessage = `Tokenization failed with status: ${tokenResult.status}`;
          if (tokenResult.errors) {
            errorMessage += ` and errors: ${JSON.stringify(
              tokenResult.errors
            )}`;
          }

          throw new Error(errorMessage);
        }
      }

      // status is either SUCCESS or FAILURE;
      function displayPaymentResults(status) {
        const statusContainer = document.getElementById(
          'payment-status-container'
        );
        if (status === 'SUCCESS') {
          statusContainer.classList.remove('is-failure');
          statusContainer.classList.add('is-success');
        } else {
          statusContainer.classList.remove('is-success');
          statusContainer.classList.add('is-failure');
        }

        statusContainer.style.visibility = 'visible';
      }

      document.addEventListener('DOMContentLoaded', async function () {
        if (!window.Square) {
          throw new Error('Square.js failed to load properly');
        }

        let payments;
        try {
          payments = window.Square.payments(appId, locationId);
        } catch {
          const statusContainer = document.getElementById(
            'payment-status-container'
          );
          statusContainer.className = 'missing-credentials';
          statusContainer.style.visibility = 'visible';
          return;
        }

        let card;
        try {
          card = await initializeCard(payments);
        } catch (e) {
          console.error('Initializing Card failed', e);
          return;
        }

        // Checkpoint 2.
        async function handlePaymentMethodSubmission(event, paymentMethod) {
          event.preventDefault();

          try {
            // disable the submit button as we await tokenization and make a payment request.
            cardButton.disabled = true;
            const token = await tokenize(paymentMethod);
            const paymentResults = await createPayment(token, event);
            displayPaymentResults('SUCCESS');

            console.debug('Payment Success', paymentResults);
          } catch (e) {
            cardButton.disabled = false;
            displayPaymentResults('FAILURE');
            console.error(e.message);
          }
        }

        const cardButton = document.getElementById('card-button');
        cardButton.addEventListener('click', async function (event) {
          await handlePaymentMethodSubmission(event, card);
        });
        
        //fetch to backend that will fetch to get token and shipping info.
      });
      // document.addEventListener("DOMContentLoaded", () => {
        
        const shippingButton = document.querySelector(".btn")
        console.log("shippingButton", shippingButton)
        shippingButton.addEventListener("click", fetchShippingCost)
        
        function fetchShippingCost(event) {
          event.preventDefault()
          const address_1 = document.querySelector("#order_addresses_attributes_0_address_1").value
          const address_2 = document.querySelector("#order_addresses_attributes_0_address_2").value
          const city = document.querySelector("#order_addresses_attributes_0_city").value
          const state = document.querySelector("#order_addresses_attributes_0_state").value
          const zipcode = document.querySelector("#order_addresses_attributes_0_zipcode").value
          const shippingOption = document.querySelector("#order_shipping_method").value
          const quantity = document.querySelector("#order_quantity").value
          fetch("http://localhost:3000/calculate_shipping",{
            method: "post", 
            headers: {
              "content-type": "application/json"
            }, 
            body: JSON.stringify({
              order: {
                addresses: [

                  {
                    address_1, 
                    address_2, 
                    city, 
                    state, 
                    zipcode, 

                },
                ],
                shippingOption,
                quantity
              }
            })
          })
          .then(response => response.json())
          .then(response => console.log("response", response))

        }
      // })


  