const _ = require('lodash');

const PHONES_BRANDS = [
    'Samsung',
    'Siemens',
    'Sony',
    'Nokia',
    'iPhone',
    'Xiaomi',
    'Alcatel'
]

const generateOnePhone = key => ({
    brand: PHONES_BRANDS[_.random(0, PHONES_BRANDS.length, false)],
    model: `${key} model ${_.random(0, 100, false)}`,
    quantity: _.random(100, 10000, false),
    price: _.random(100, 10000, true)
})

module.exports.generatePhones = (length = 50) => {
    return new Array(length).fill(null).map((el, key) => generateOnePhone(key));
}