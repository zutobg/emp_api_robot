auth = ['codemonster', 'my5ecret-key2o2o']
base_url = 'http://localhost:3001'
payment_body_sale = {'card_number':'4200000000000000','cvv':'123','expiration_date':'06/2019','amount':'500','usage':'Coffeemaker','transaction_type':'sale','card_holder':'Panda Panda','email':'panda@example.com','address':'Panda Street, China'}
payment_body_sale_500_error_value = {'card_number':'4200000000000000','cvv':'123','expiration_date':'06/2019','amount':'500000000000','usage':'Coffeemaker','transaction_type':'sale','card_holder':'Panda Panda','email':'panda@example.com','address':'Panda Street, China'}
tx_id_invalid_guid = 'xxxxxxxxce3472459704dc43040f1111'
payment_body_sale_declined = {'card_number':'4111111111111111','cvv':'123','expiration_date':'06/2019','amount':'500','usage':'Coffeemaker','transaction_type':'sale','card_holder':'Panda Panda','email':'panda@example.com','address':'Panda Street, China'}