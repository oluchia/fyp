package bank;

import java.io.Serializable;
import java.util.Date;
import java.util.List;
import client.Transaction;

public interface Statement extends Serializable {
	
	public int getAccountNum();
	public Date getStartDate();
	public Date getEndDate();
	public String getAccountName();
	public List<Transaction> getTransactions();

}