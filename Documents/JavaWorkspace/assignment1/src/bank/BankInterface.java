package bank;

import java.rmi.Remote;
import bank.InvalidLogin;
import bank.InvalidSession;
import java.rmi.RemoteException;
import java.util.Date;

public interface BankInterface extends Remote {

	public long login(String username, String password) throws RemoteException, InvalidLogin;
	public void deposit(int accountNum, int amount, long sessionID) throws RemoteException, InvalidSession;
	public void withdraw(int accountNum, int amount, long sessionID) throws RemoteException, InvalidSession;
	public int inquiry(int accountNum, long sessionID) throws RemoteException, InvalidSession;
	public Statement getStatement(Date to, Date from, long sessionID) throws RemoteException, InvalidSession;
	
}