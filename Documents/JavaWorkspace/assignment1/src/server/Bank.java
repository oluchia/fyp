package server;

import java.rmi.RemoteException;
import java.rmi.server.UnicastRemoteObject;
import java.util.Date;
import java.util.List;

import bank.BankInterface;
import bank.InvalidLogin;
import bank.InvalidSession;
import bank.Statement;
import client.Account;

public class Bank extends UnicastRemoteObject implements BankInterface {

	private List<Account> accounts; // users accounts

	public Bank() throws RemoteException
	{

	}
	public void deposit(int account, int amount) throws RemoteException, InvalidSession {

	// implementation code

	}

	public void withdraw(int account, int amount) throws RemoteException, InvalidSession {

	// implementation code

	}

	public int inquiry(int account) throws RemoteException, InvalidSession {

	// implementation code

	}

	public Statement getStatement(Date from, Date to) throws RemoteException, InvalidSession {

	// implementation code

	}

	public static void main(String args[]) throws Exception {

	// initialise Bank server - see sample code in the notes and online RMI tutorials for details

	}
	@Override
	public long login(String username, String password) throws RemoteException, InvalidLogin {
		// TODO Auto-generated method stub
		return 0;
	}
	@Override
	public void deposit(int accountNum, int amount, long sessionID) throws RemoteException, InvalidSession {
		// TODO Auto-generated method stub
		
	}
	@Override
	public void withdraw(int accountNum, int amount, long sessionID) throws RemoteException, InvalidSession {
		// TODO Auto-generated method stub
		
	}
	@Override
	public int inquiry(int accountNum, long sessionID) throws RemoteException, InvalidSession {
		// TODO Auto-generated method stub
		return 0;
	}
	@Override
	public Statement getStatement(Date to, Date from, long sessionID) throws RemoteException, InvalidSession {
		// TODO Auto-generated method stub
		return null;
	}

}