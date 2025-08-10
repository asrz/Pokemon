package asrz.Pokemon.model.enums;

import static asrz.Pokemon.model.enums.Stat.*;

import java.util.List;

import asrz.Pokemon.util.Util;
import asrz.Pokemon.model.enums.Nature;
import java.util.Collection;

public enum Nature {

	HARDY("Hardy", ATTACK, ATTACK),
	LONELY("Lonely", ATTACK, DEFENSE),
	ADAMANT("Adamant", ATTACK, SPECIAL_ATTACK),
	NAUGHTY("Naughty", ATTACK, SPECIAL_DEFENSE),
	BRAVE("Brave", ATTACK, SPEED),
	
	BOLD("Bold", DEFENSE, ATTACK),
	DOCILE("Docile", DEFENSE, DEFENSE),
	IMPISH("Impish", DEFENSE, SPECIAL_ATTACK),
	LAX("Lax", DEFENSE, SPECIAL_DEFENSE),
	RELAXED("Relaxed", DEFENSE, SPEED),
	
	MODEST("Modest", SPECIAL_ATTACK, ATTACK),
	MILD("Mild", SPECIAL_ATTACK, DEFENSE),
	BASHFUL("Bashful", SPECIAL_ATTACK, SPECIAL_ATTACK),
	RASH("Rash", SPECIAL_ATTACK, SPECIAL_DEFENSE),
	QUIET("Quiet", SPECIAL_ATTACK, SPEED),
	
	CALM("Calm", SPECIAL_DEFENSE, ATTACK),
	GENTLE("Gentle", SPECIAL_DEFENSE, DEFENSE),
	CAREFUL("Careful", SPECIAL_DEFENSE, SPECIAL_ATTACK),
	QUIRKY("Quirky", SPECIAL_DEFENSE, SPECIAL_DEFENSE),
	SASSY("Sassy", SPECIAL_DEFENSE, SPEED),
	
	TIMID("Timid", SPEED, ATTACK),
	HASTY("Hasty", SPEED, DEFENSE),
	JOLLY("Jolly", SPEED, SPECIAL_ATTACK),
	NAIVE("Naive", SPEED, SPECIAL_DEFENSE),
	SERIOUS("Serious", SPEED, SPEED),
	;
	
	private String label;
	private Stat buffedStat;
	private Stat debuffedStat;
	
	private Nature(String label, Stat buffedStat, Stat debuffedStat) {
		this.label = label;
		this.buffedStat = buffedStat;
		this.debuffedStat = debuffedStat;
	}

	public String getLabel() { return label; }
	public Stat getBuffedStat() { return buffedStat; }
	public Stat getDebuffedStat() { return debuffedStat; }
	
	public static List<Nature> list() {
		return Util.list(values());
	}
	
	public double getStatModifier(Stat stat) {
		if (buffedStat == stat) {
			if (debuffedStat == stat) {
				return 1.0;
			} else {
				return 1.1;
			}
		} else {
			if (debuffedStat == stat) {
				return 0.9;
			} else {
				return 1.0;
			}
		}
	}

	public static Collection<Nature> getNeutralNatures() {
		return Util.list(HARDY, DOCILE, BASHFUL, QUIRKY, SERIOUS);
	}
	
}
