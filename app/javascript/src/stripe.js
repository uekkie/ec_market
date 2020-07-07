var script = document.createElement('script');
script.src = 'https://js.stripe.com/v3/';
document.head.appendChild(script);

window.addEventListener('load', (event) => {
    if (typeof gon === 'undefined') {
        return
    }

    var stripe = Stripe(gon.stripe_publishable_key, {locale: 'ja'});
    var elements = stripe.elements();
    var style = {
        base: {
            color: '#32325d',
            fontFamily: '"Helvetica Neue", Helvetica, sans-serif',
            fontSmoothing: 'antialiased',
            fontSize: '16px',
            '::placeholder': {
                color: '#aab7c4'
            }
        },
        invalid: {
            color: '#fa755a',
            iconColor: '#fa755a'
        }
    };
    var card = elements.create('card', {style: style, hidePostalCode: true});
    card.mount('#card-element');

    card.addEventListener('change', function (event) {
        var displayError = document.getElementById('card-errors');
        if (event.error) {
            displayError.textContent = event.error.message;
        } else {
            displayError.textContent = '';
        }
    });

    var form = document.getElementById('payment-form');
    let handleCardValidation = function (event) {
        event.preventDefault();

        if (skip_card_validation()) {
            var form = document.getElementById('payment-form');
            form.submit();
            return
        }

        stripe.createToken(card).then(function (result) {
            if (result.error) {
                var errorElement = document.getElementById('card-errors');
                errorElement.textContent = result.error.message;
            } else {
                stripeTokenHandler(result.token);
            }
        });
    }
    form.addEventListener('submit', handleCardValidation);

    function stripeTokenHandler(token) {
        var form = document.getElementById('payment-form');
        var hiddenInput = document.createElement('input');
        hiddenInput.setAttribute('type', 'hidden');
        hiddenInput.setAttribute('name', 'stripeToken');
        hiddenInput.setAttribute('value', token.id);
        form.appendChild(hiddenInput);

        form.submit();
    }

    function skip_card_validation() {
        var radio_cash_on_delivery = document.getElementById('order_purchased_type_cash_on_delivery');
        if (radio_cash_on_delivery && radio_cash_on_delivery.checked)
            return true

        var radio_use_registered_card = document.getElementById('use_registered_card');

        if (radio_use_registered_card && radio_use_registered_card.checked)
            return true
    }
});

