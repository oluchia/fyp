package client;

import java.rmi.registry.*;

import bank.BankInterface;

public class ATM {

	public static void main (String args[]) throws Exception {
		// get user’s input, and perform the operations
		if (System.getSecurityManager() == null) {
			System.setSecurityManager(new SecurityManager());
		}
		
		try {
			String name = "Bank";
			Registry registry = LocateRegistry.getRegistry(args[0]);
			BankInterface bank = (BankInterface) registry.lookup(name);
			
		} catch (Exception e) {
			System.err.println("ATM Exception: ");
			e.printStackTrace();
		}

	}

}