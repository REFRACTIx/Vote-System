#include <a_samp>
#include <sscanf2>
#include <zcmd>

#define VOTE_TIME    20000 // Oylama bitiþ süresi

new bool:votestart;

new Text:votetext;
new Text:sorutext;

new VoteYes;
new VoteNo;	

new bool:voted[MAX_PLAYERS];

public OnFilterScriptInit()
{
	print("Vote system by REFRACTIx");
	votestart = false;
	sorutext = TextDrawCreate(9.000000, 305.000000, "~w~(~r~VOTE~w~) Soru");
	TextDrawBackgroundColor(sorutext, 96);
	TextDrawFont(sorutext, 1);
	TextDrawLetterSize(sorutext, 0.300000, 1.300000);
	TextDrawColor(sorutext, -1);
	TextDrawSetOutline(sorutext, 1);
	TextDrawSetProportional(sorutext, 1);
	TextDrawSetSelectable(sorutext, 0);

	votetext = TextDrawCreate(9.000000, 325.000000, "~g~Evet: ~w~0 ~r~Hayir: ~w~0");
	TextDrawBackgroundColor(votetext, 96);
	TextDrawFont(votetext, 1);
	TextDrawLetterSize(votetext, 0.300000, 1.300000);
	TextDrawColor(votetext, -1);
	TextDrawSetOutline(votetext, 1);
	TextDrawSetProportional(votetext, 1);
	TextDrawSetSelectable(votetext, 0);
	return 1;
}
public OnFilterScriptExit()
{
	return 1;
}

forward VoteCount();
public VoteCount()
{	
	TextDrawHideForAll(votetext);
	TextDrawHideForAll(sorutext);		
	votestart = false;	
	new a[128];	
	format(a, sizeof(a),  "[{FFAA00}VOTE{FFFFFF}] Oylama sona erdi. | {00FF00}Evet: {FFFFFF}%d - {FF0000}Hayýr: {FFFFFF}%d", VoteYes, VoteNo);	
	SendClientMessageToAll(-1, a);	
	VoteYes = 0;	VoteNo = 0;	
	for(new i = 0; i < MAX_PLAYERS; i++)	
	{		
		if(IsPlayerConnected(i))		
		{					
			voted[i] = false;		
		}	
	}	
	return 1;
}


public OnPlayerKeyStateChange(playerid,newkeys,oldkeys)
{
	if(votestart == false) return 1;
	if(newkeys & KEY_YES && votestart == true && voted[playerid] == false)
	{
		voted[playerid] = true;
		VoteYes ++;
		SendClientMessage(playerid, -1, "Oyunu {00FF00}Evet {FFFFFF}olarak kullandýn. Oylamanýn bitmesini bekle");
		new result[50];
		format(result,sizeof result,"~g~Evet: ~w~%d ~r~Hayir: ~w~%d",VoteYes,VoteNo);
		TextDrawSetString(votetext,result);
	}
	else if(newkeys & KEY_NO && votestart == true && voted[playerid] == false)
	{
		voted[playerid] = true;
		VoteNo ++;
		SendClientMessage(playerid, -1, "Oyunu {FF0000}Hayýr {FFFFFF}olarak kullandýn. Oylamanýn bitmesini bekle");
		new result[50];
		format(result,sizeof result,"~g~Evet: ~w~%d ~r~Hayir: ~w~%d",VoteYes,VoteNo);
		TextDrawSetString(votetext,result);
	}
	return 1;
}

CMD:vote(playerid, params[])
{
	if(votestart == true) return SendClientMessage(playerid,-1,"Bir oylama zaten baþlatýlmýþ.");
	new string[64];
	if(sscanf(params,"s[64]",string)) return SendClientMessage(playerid, -1, "/vote [Soru]");
	new a[128+24];
	SendClientMessageToAll(-1, "[{FFAA00}VOTE{FFFFFF}] Bir oylama baþlatýldý. Evet demek için {00FF00}'Y' {FFFFFF}tuþuna, Hayýr demek için {FF0000}'N' {FFFFFF}tuþuna basýn.");
	format(a, sizeof(a), "~w~(~r~VOTE~w~) %s", string);
	TextDrawSetString(sorutext, a);
	TextDrawShowForAll(sorutext);
	TextDrawSetString(votetext,"~g~Evet: ~w~0 ~r~Hayir: ~w~0");
	TextDrawShowForAll(votetext);
	SetTimer("VoteCount",VOTE_TIME,false);
	votestart = true;
	return 1;
}

stock GetName(playerid)
{
	new name[24];
	GetPlayerName(playerid,name,24);
	return name;
}	