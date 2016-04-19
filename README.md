# FPlanner

FPlanner is a CoffeeScript tool to prioritise and calculate debt payments and work out your debt-free date.

## Installation

```bash
npm install
```

## Configuration

Please modify [config.coffee](config.coffee) to suit your requirements. 

Set `start` to the date to start from (next payday, for instance), and `frequency` to `weekly`, `fortnightly` or `monthly`. All amounts are assumed to be available or due on these dates.
Each catgeory can take an unlimited number of rows, for best results enter your income, expenditure and debts in as much detail as possible.

Minimum payments on loans can either be specified by a `minimum` amount, or also by a `minPercentage` of the outstanding amount. If you specify a `minPercentage`, the greater of the two amounts will be assumed to be the minimum payment.

## Running

```bash
npm start
```

A plan of payments will be displayed under `Payment Plan`, e.g.

```
2016-06-01 Student Loan $182.50 ($6817.50), Credit Card $62.50 ($2437.50)
```

This is the date to pay, followed by a list of payments to make, with the resulting balance in brackets. Debts are prioritised by a weighting factor depending on their interest rates and amounts.

## Disclaimer

This software is provided as-is, without any guarantee of accuracy or fitness for any particular purpose. You should consult a registered accountant or qualified financial advisor regarding any financial plan.