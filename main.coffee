_ = require "underscore"
Decimal = require "decimal.js"
dateformat = require "dateformat"

config = require "./config"

# Func

daydiff = (first, second) ->
    Math.round((second-first)/(1000*60*60*24))

getWeight = (name, loan) ->
	loan.amount.mul(loan.apr)
	# loan.apr

# Data

loanWeighting = [] 
loanWeighting.push({name:pname, weighting: getWeight(name, x)}) for pname, x of config.loans
loanWeighting = _.sortBy(loanWeighting, 'weighting').reverse()

payments = []

console.log("FPlanner v0.0.1\n")

# Start

today = config.start
last = today

incomeTotal = new Decimal(0)
fixedExpenditureTotal = new Decimal(0)

incomeTotal = incomeTotal.add(x.amount) for name, x of config.income
fixedExpenditureTotal = fixedExpenditureTotal.add(x.amount) for name, x of config.expenditure

console.log("- Schedule -----------")
console.log("From "+dateformat(today, "yyyy-mm-dd")+", "+config.frequency)
console.log("- Expenses -----------")
for name, expense of config.expenditure
	console.log("#{name} $"+expense.amount.toFixed(2))
console.log("- Totals -------------")
console.log("Total Income $"+incomeTotal.toFixed(2))
console.log("Total Fixed Expenditure $"+fixedExpenditureTotal.toFixed(2))
console.log("Total Repayment Available $"+incomeTotal.sub(fixedExpenditureTotal).toFixed(2))
console.log("- Payment Plan -------")

x = 0


while Object.keys(config.loans).length > 0 
	total = incomeTotal.sub(fixedExpenditureTotal)

	outStr = dateformat(today, "yyyy-mm-dd")
	console.log("\n--- Processing "+outStr) if config.debug

	interest = {}
	out = {}

	# Add Interest
	days = daydiff(last, today)
	for name, loan of config.loans
		interest[name] = loan.amount.mul(loan.apr).mul(days).div(36500)
		loan.amount = loan.amount.add(interest[name])

	# Work out minimum payments
	for name, loan of config.loans
		owedNow = loan.minimum
		owedNow = Decimal.max(owedNow, loan.amount.mul(loan.minPercentage).div(100)) if loan.minPercentage?
		owedNow = Decimal.min(owedNow, loan.amount)
		console.log("minimum - #{name} - Left #{total}, minimum: #{loan.minimum}, loan amount #{loan.amount}, min of two #{owedNow}") if config.debug
		out[name] = owedNow
		total = total.sub(owedNow)

	# Work out extra in order of weight desc
	for x in loanWeighting
		loan = config.loans[x.name]
		continue unless loan? and loan.amount.greaterThan(new Decimal(0))

		ex = Decimal.min(total, loan.amount.sub(out[x.name]))
		console.log("Extra - #{x.name} - Left: #{total}, loan amount #{loan.amount-out[x.name]}, min of two #{ex}") if config.debug
		out[x.name] = out[x.name].add(ex)
		total = total.sub(ex)
		break if total.equals(new Decimal(0)) or total.lessThan(new Decimal(0))
			
	# Make Payments
	for name, loan of config.loans
		loan.amount = loan.amount.sub(out[name])

	# Print payments

	for name, loan of config.loans
		outStr += " "+name+" $"+out[name].toFixed(2)+" ($"+loan.amount.toFixed(2)+"),"

	outStr = outStr.slice(0,-1) if outStr.length > 0

	toDelete = []
	for name, loan of config.loans
		toDelete.push(name) if loan.amount.equals(new Decimal(0))
	
	delete config.loans[name] for name in toDelete

	console.log outStr

	last = new Date(today.getTime())

	switch config.frequency 
		when "weekly" then today.setDate(today.getDate() + 7)
		when "fortnightly" then today.setDate(today.getDate() + 14)
		when "monthly" then today.setMonth(today.getMonth() + 1)

console.log("- Completion -------")
console.log("Debt Free Date: #{dateformat(last, "yyyy-mm-dd")}")
