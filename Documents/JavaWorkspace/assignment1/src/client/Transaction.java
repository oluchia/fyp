package client;

import java.util.Date;

public class Transaction {
	
	private String transactionType;
	private double amount;
	private Date date;
	
	public Transaction(String type, double amount, Date date) {
		this.transactionType = type;
		this.amount = amount;
		this.date = date;
	}
	
	public String getTransactionType() {
		return transactionType;
	}
	
	public void setTransactionType(String transactionType) {
		this.transactionType = transactionType;
	}
	
	public double getAmount() {
		return amount;
	}
	
	public void setAmount(double amount) {
		this.amount = amount;
	}
	
	public Date getDate() {
		return date;
	}
	
	public void setDate(Date date) {
		this.date = date;
	}

	@Override
	public String toString() {
		return "Transaction [transactionType=" + transactionType + ", amount=" + amount + ", date=" + date + "]";
	}
	
	
}