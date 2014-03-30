/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package com.quickserverlab.quicklb.server;

import java.util.concurrent.atomic.AtomicLong;

/**
 *
 * @author akshath
 */
public class InterfaceStats {
	private AtomicLong clientCount = new AtomicLong();
	private AtomicLong inByteCount = new AtomicLong();
	private AtomicLong outByteCount = new AtomicLong();
	private AtomicLong droppedCount = new AtomicLong();
	private AtomicLong conErrorCount = new AtomicLong();
	private long downTime; 

	/**
	 * @return the inByteCount
	 */
	public AtomicLong getInByteCount() {
		return inByteCount;
	}

	/**
	 * @param inByteCount the inByteCount to set
	 */
	public void setInByteCount(AtomicLong inByteCount) {
		this.inByteCount = inByteCount;
	}

	/**
	 * @return the outByteCount
	 */
	public AtomicLong getOutByteCount() {
		return outByteCount;
	}

	/**
	 * @param outByteCount the outByteCount to set
	 */
	public void setOutByteCount(AtomicLong outByteCount) {
		this.outByteCount = outByteCount;
	}

	/**
	 * @return the droppedCount
	 */
	public AtomicLong getDroppedCount() {
		return droppedCount;
	}

	/**
	 * @param droppedCount the droppedCount to set
	 */
	public void setDroppedCount(AtomicLong droppedCount) {
		this.droppedCount = droppedCount;
	}

	/**
	 * @return the conErrorCount
	 */
	public AtomicLong getConErrorCount() {
		return conErrorCount;
	}

	/**
	 * @param conErrorCount the conErrorCount to set
	 */
	public void setConErrorCount(AtomicLong conErrorCount) {
		this.conErrorCount = conErrorCount;
	}

	/**
	 * @return the downTime
	 */
	public long getDownTime() {
		return downTime;
	}
	
	public void addDownTime(long downtime) {
		this.downTime = this.downTime + downtime;
	}
	
	private static final int SECOND = 1000;
	private static final int MINUTE = 60 * SECOND;
	private static final int HOUR = 60 * MINUTE;
	private static final int DAY = 24 * HOUR;
	
	public String getDownTimeText() {
		long ms = downTime;
		
		StringBuilder sb = new StringBuilder();		
		
		if (ms > DAY) {
			sb.append(ms / DAY).append("d ");
			ms %= DAY;
		}
		if (ms > HOUR) {
			sb.append(ms / HOUR).append("h ");
			ms %= HOUR;
		}
		if (ms > MINUTE) {
			sb.append(ms / MINUTE).append("m ");
			ms %= MINUTE;
		}
		if (ms > SECOND) {
			sb.append(ms / SECOND).append("s");
			ms %= SECOND;
		}
		//sb.append(ms).append("ms");

		
		return sb.toString();
	}

	/**
	 * @return the clientCount
	 */
	public AtomicLong getClientCount() {
		return clientCount;
	}

	/**
	 * @param clientCount the clientCount to set
	 */
	public void setClientCount(AtomicLong clientCount) {
		this.clientCount = clientCount;
	}
}
