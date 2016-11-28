--Blessing of the Flora Goddess
--  Idea: Aslan
--  Script: Shad3
--[[
Reveal 1 monster in your Extra Deck that lists "Gemini" in its card text, then discard monsters whose combined Levels are equal to or greater than the revealed monster's Level/Rank; Special Summon that monster. You can only activate 1 "Blessing of the Flora Goddess" per turn.
--]]

local function getID()
	local str=string.match(debug.getinfo(2,'S')['source'],"c%d+%.lua")
	str=string.sub(str,1,string.len(str)-4)
	local scard=_G[str]
	local s_id=tonumber(string.sub(str,2))
	return scard,s_id
end

local scard,s_id=getID()

--common Flora functions & effects
if not Auxiliary.FloraCommons then
	Auxiliary.FloraCommons=true
	--Normalmonster in PZone
	local cgt=Card.GetType
	Card.GetType=function(c)
		if c:IsLocation(LOCATION_EXTRA) and c:IsHasEffect(121200100) then
			return bit.bxor(cgt(c),TYPE_EFFECT+TYPE_NORMAL)
		else
			return cgt(c)
		end
	end
	local cit=Card.IsType
	Card.IsType=function(c,ty)
		if c:IsLocation(LOCATION_EXTRA) and c:IsHasEffect(121200100) then
			return bit.band(c:GetType(),ty)~=0
		else
			return cit(c,ty)
		end
	end
	--Flora Set card
	function Auxiliary.SetCardFlora(c)
		return c:IsSetCard(0xa8b) or c:IsCode(36318200,500000142,500000143,511000002)
	end
	--mentions Gemini in Extra Deck
	function Auxiliary.GeminiMentionExtra(c)
		if c.mention_gemini then return true end
		local cd=c:GetOriginalCode()
		return cd==64463828 or cd==96029574 or cd==38026562
	end
end

function scard.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetCountLimit(1,s_id+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(scard.a_cs)
	e1:SetTarget(scard.a_tg)
	e1:SetOperation(scard.a_op)
	c:RegisterEffect(e1)
end

function scard.a_fil(c,e,tp,g)
	if aux.GeminiMentionExtra(c) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) then
		local lv=c:GetLevel()
		if lv<1 then lv=c:GetRank() end
		return g:CheckWithSumGreater(Card.GetLevel,lv,1,63)
	else
		return false
	end
end

function scard.a_dfil(c)
	return c:IsDiscardable() and c:IsLevelAbove(1)
end

function scard.a_cs(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(scard.a_dfil,tp,LOCATION_HAND,0,nil)
	if chk==0 then return Duel.IsExistingMatchingCard(scard.a_fil,tp,LOCATION_EXTRA,0,1,nil,e,tp,g) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,scard.a_fil,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,g):GetFirst()
	local lv=tc:GetLevel()
	if lv<1 then lv=tc:GetRank() end
	Duel.ConfirmCards(1-tp,tc)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local dg=g:SelectWithSumGreater(tp,Card.GetLevel,lv,1,63)
	Duel.SendtoGrave(dg,REASON_COST+REASON_DISCARD)
	e:SetLabelObject(tc)
end

function scard.a_tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local tc=e:GetLabelObject()
	if not tc then return end
	Duel.SetTargetCard(tc)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,tc,1,0,0)
	e:SetLabelObject(nil)
end

function scard.a_op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP) end
end
