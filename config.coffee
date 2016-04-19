Decimal = require "decimal.js"

module.exports = 
	start: new Date(2016,5,1)
	frequency: "weekly"

	income:
		Salary: { amount: new Decimal("700") }

	expenditure:
		Rent:           { amount: new Decimal("210.0") }
		Food:           { amount: new Decimal("50.00") }
		Internet:       { amount: new Decimal("25.00") }
		Phone:          { amount: new Decimal("10.00") }
		Savings:        { amount: new Decimal("10.00") }
		Disposable:     { amount: new Decimal("150.00") }

	loans:
		"Student Loan":   { amount: new Decimal("7000"), minimum: new Decimal("20.00"), apr: new Decimal("8.00") }
		"Credit Card":    { amount: new Decimal("2500.00"), minimum: new Decimal("12.50"),  minPercentage: new Decimal("2.5"), apr: new Decimal("17.85") }
