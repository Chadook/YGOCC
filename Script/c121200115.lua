--Shiranui Style Seven Stars
--  Idea: SlackerMagician http://slackermagician.deviantart.com/
--  Script: Shad3
--[[
Target 2 of your banished Zombie-Type monsters (1 Tuner and 1 non-Tuner); shuffle them into the Deck, and Special Summon 1 Synchro Monster from your Extra Deck with Level equal to the total Levels of those returned cards. (This Special Summon is treated as a Synchro Summon.) You can banish this card from your Graveyard and 1 card from your hand; Add 1 "Shiranui" card from your Deck to your hand, except "Shiranui Style Seven Stars". You can only use 1 effect of "Shiranui Style Seven Stars" per turn, and only once that turn.
--]]

local function getID()
	local str=string.match(debug.getinfo(2,'S')['source'],"c%d+%.lua")
	str=string.sub(str,1,string.len(str)-4)
	local scard=_G[str]
	local s_id=tonumber(string.sub(str,2))
	return scard,s_id
end

local scard,s_id=getID()

function scard.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
	e1:SetCountLimit(1,s_id)
	e1:SetDescription(aux.Stringid(s_id,0))
	e1:SetTarget(scard.a_tg)
	e1:SetOperation(scard.a_op)
	c:RegisterEffect(e1)
	--Add
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetCountLimit(1,s_id)
	e2:SetDescription(aux.Stringid(s_id,1))
	e2:SetCost(scard.b_cs)
	e2:SetTarget(scard.b_tg)
	e2:SetOperation(scard.b_op)
	c:RegisterEffect(e2)
end

function scard.a_fil1(c,e,tp)
	if c:IsType(TYPE_MONSTER) and c:IsRace(RACE_ZOMBIE) and c:IsType(TYPE_TUNER) then
		local lv=c:GetLevel()
		return lv>0 and Duel.IsExistingTarget(scard.a_fil2,tp,LOCATION_REMOVED,0,1,c,e,tp,lv)
	end
	return false
end

function scard.a_fil2(c,e,tp,lv)
	if c:IsType(TYPE_MONSTER) and c:IsRace(RACE_ZOMBIE) and not c:IsType(TYPE_TUNER) then
		local slv=c:GetLevel()
		return slv>0 and Duel.IsExistingMatchingCard(scard.a_sfil,tp,LOCATION_EXTRA,0,1,nil,e,tp,slv+lv)
	end
	return false
end

function scard.a_sfil(c,e,tp,lv)
	return c:IsType(TYPE_SYNCHRO) and c:GetLevel()==lv and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false)
end

function scard.a_tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(scard.a_fil1,tp,LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,scard.a_fil1,tp,LOCATION_REMOVED,0,1,1,nil,e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g2=Duel.SelectTarget(tp,scard.a_fil2,tp,LOCATION_REMOVED,0,1,1,g:GetFirst(),e,tp,g:GetFirst():GetLevel())
	g:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end

function scard.a_op(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if tg:FilterCount(Card.IsRelateToEffect,nil,e)~=2 then return end
	local lv=tg:GetSum(Card.GetLevel)
	local sg=Duel.GetMatchingGroup(scard.a_sfil,tp,LOCATION_EXTRA,0,nil,e,tp,lv)
	if sg:GetCount()>0 and Duel.SendtoDeck(tg,nil,2,REASON_EFFECT)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sc=sg:Select(tp,1,1,nil):GetFirst()
		Duel.SpecialSummon(sc,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP)
		sc:CompleteProcedure()
	end
end

function scard.b_fil(c)
	return c:IsSetCard(0xd9) and not c:IsCode(s_id)
end

function scard.b_cs(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() and Duel.IsExistingMatchingCard(Card.IsAbleToRemoveAsCost,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemoveAsCost,tp,LOCATION_HAND,0,1,1,nil)
	g:AddCard(e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end

function scard.b_tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(scard.b_fil,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end

function scard.b_op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,scard.b_fil,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
