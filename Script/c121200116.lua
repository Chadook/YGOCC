--Shiranui Samuraipsyche
--  Idea: SlackerMagician http://slackermagician.deviantart.com/
--  Script: Shad3
--[[
1 Zombie-Type Tuner + 1 Zombie-Type non-Tuner monster
You can only Special Summon "Shiranui Samuraipsyche" once per turn. Once per turn: You can shuffle all of your banished "Shiranui" monsters into the Deck, and if 3 or more cards are returned this way, draw 1 card. If this card is banished: You can send 1 "Shiranui Spectralsword" from your Deck to the Graveyard; Special Summon 1 "Shiranui" monster from your Deck.
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
	c:SetSPSummonOnce(s_id)
	aux.AddSynchroProcedure2(c,scard.sfil,aux.NonTuner(scard.sfil))
	c:EnableReviveLimit()
	--Shuffle
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e1:SetCountLimit(1)
	e1:SetDescription(aux.Stringid(s_id,0))
	e1:SetTarget(scard.a_tg)
	e1:SetOperation(scard.a_op)
	c:RegisterEffect(e1)
	--Spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_REMOVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetDescription(aux.Stringid(s_id,1))
	e2:SetCost(scard.b_cs)
	e2:SetTarget(scard.b_tg)
	e2:SetOperation(scard.b_op)
	c:RegisterEffect(e2)
end

function scard.sfil(c)
	return c:IsRace(RACE_ZOMBIE)
end

function scard.a_fil(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xd9) and c:IsAbleToDeck()
end

function scard.a_tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(scard.a_fil,tp,LOCATION_REMOVED,0,1,nil) end
	local g=Duel.GetMatchingGroup(scard.a_fil,tp,LOCATION_REMOVED,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
	if g:GetCount()>3 then Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1) end
end

function scard.a_op(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(scard.a_fil,tp,LOCATION_REMOVED,0,nil)
	if g:GetCount()>0 and Duel.SendtoDeck(g,nil,2,REASON_EFFECT)>=3 then
		if g:Filter(Card.IsLocation,nil,LOCATION_DECK):FilterCount(Card.IsControler,nil,tp)>0 then Duel.ShuffleDeck(tp) end
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end

function scard.b_csfil(c,e,tp)
	return c:IsCode(36630403) and c:IsAbleToGraveAsCost() and Duel.IsExistingMatchingCard(scard.b_fil,tp,LOCATION_DECK,0,1,c,e,tp)
end

function scard.b_fil(c,e,tp)
	return c:IsSetCard(0xd9) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function scard.b_cs(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(scard.b_csfil,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,scard.b_csfil,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	Duel.SendtoGrave(g,REASON_COST)
end

function scard.b_tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(scard.b_fil,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end

function scard.b_op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,scard.b_fil,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP) end
end
