--Protector of the Flora - Necrotic Buxus
--  Idea: Aslan
--  Script: Shad3
--[[
2 Level 5 Gemini monsters
"Flora" monsters you control cannot be targeted by an opponent's card effects. You can detach 1 Xyz Material from this card; Special Summon 1 Gemini monster from your Graveyard, and if you do, it is treated as an Effect Monster and its Level becomes 5, until the End Phase. You can only control 1 "Protector of the Flora" monster.
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
	c:SetUniqueOnField(1,0,0x10001a8b)
	--Xyz Summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsType,TYPE_DUAL),5,2)
	c:EnableReviveLimit()
	--untargetable
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(scard.a_tg)
	e1:SetValue(aux.tgoval)
	c:RegisterEffect(e1)
	--Spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetDescription(aux.Stringid(s_id,0))
	e2:SetCost(scard.b_cs)
	e2:SetTarget(scard.b_tg)
	e2:SetOperation(scard.b_op)
	c:RegisterEffect(e2)
end

scard.mention_gemini=true

function scard.a_tg(e,c)
	return aux.SetCardFlora(c)
end

function scard.b_fil(c,e,tp)
	return c:IsType(TYPE_DUAL) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function scard.b_cs(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end

function scard.b_tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(scard.b_fil,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end

function scard.b_op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,scard.b_fil,tp,LOCATION_GRAVE,0,1,1,nil,e,tp):GetFirst()
	if tc and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DUAL_STATUS)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_CHANGE_LEVEL)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e2:SetValue(5)
		tc:RegisterEffect(e2)
	end
end
