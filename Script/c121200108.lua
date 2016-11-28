--Protector of the Flora - Azollae
--  Idea: Aslan
--  Script: Shad3
--[[
2 Level 7 Gemini monsters
As long as this card has Xyz Material, other "Flora" monsters you control gains 500 ATK and DEF, also they cannot be destroyed by battle or card effects. When a monster(s) would be Special Summoned: You can detach 2 Xyz Materials from this card; negate the Summon of those monsters, and if you do, destroy cards on the field equal to the number of monsters sent to the Graveyard by this effect. You can only control 1 "Protector of the Flora" monster.
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
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsType,TYPE_DUAL),7,2)
	c:EnableReviveLimit()
	--Manyeffects
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetCondition(scard.a_cd)
	e1:SetTarget(scard.a_tg)
	e1:SetValue(500)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	local e4=e1:Clone()
	e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	--NegateSum
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_SPSUMMON)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCategory(CATEGORY_DISABLE_SUMMON)
	e5:SetDescription(aux.Stringid(s_id,0))
	e5:SetCondition(scard.b_cd)
	e5:SetCost(scard.b_cs)
	e5:SetTarget(scard.b_tg)
	e5:SetOperation(scard.b_op)
	c:RegisterEffect(e5)
end

scard.mention_gemini=true

function scard.a_cd(e)
	return e:GetHandler():GetOverlayCount()>0
end

function scard.a_tg(e,c)
	return c~=e:GetHandler() and aux.SetCardFlora(c)
end

function scard.b_cd(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==0
end

function scard.b_cs(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,2,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,2,2,REASON_COST)
end

function scard.b_tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local ct=eg:GetCount()
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,eg:GetCount(),0,0)
	local g=Duel.GetFieldGroup(tp,LOCATION_ONFIELD,LOCATION_ONFIELD):Sub(eg)
	ct=math.min(g:GetCount(),ct)
	if ct>0 then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,ct,0,0)
	end
end

function scard.b_op(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateSummon(eg)
	local n=eg:FilterCount(Card.IsLocation,nil,LOCATION_GRAVE)
	if n>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,n,n,nil)
		if g:GetCount()>0 then Duel.Destroy(g,REASON_EFFECT) end
	end
end
