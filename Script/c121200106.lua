--Guardian of the Flora - Sagis
--  Idea: Aslan
--  Script: Shad3
--[[
This card is treated as a Normal Monster while face-up on the field or in the Graveyard or Extra Deck. While this card is a Normal Monster on the field, you can Normal Summon it to have it become an Effect Monster with these effects.
● Once per turn: You can Tribute other monsters you control (max. 2); increase this card's Level by twice the amount of the Tributed monsters, as long as this card is face-up on the field.
● This Level 5 or higher card cannot be targeted by an opponent's card effects.
● When this Level 7 or higher card attacks or is attacked: It gains 1000 ATK and DEF until the End Phase.
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
	aux.EnableDualAttribute(c)
	aux.EnablePendulumAttribute(c)
	--norpendulum
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(121200100)
	c:RegisterEffect(e0)
	--level increase
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetDescription(aux.Stringid(s_id,0))
	e1:SetCondition(aux.IsDualState)
	e1:SetCost(scard.a_cs)
	e1:SetOperation(scard.a_op)
	c:RegisterEffect(e1)
	--Untargetable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetDescription(aux.Stringid(s_id,1))
	e2:SetCondition(scard.b_cd)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
	--ATK+DEFup
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_ATTACK_ANNOUNCE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e3:SetDescription(aux.Stringid(s_id,2))
	e3:SetCondition(scard.c_cd)
	e3:SetTarget(scard.c_tg)
	e3:SetOperation(scard.c_op)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_BE_BATTLE_TARGET)
	c:RegisterEffect(e4)
end

function scard.a_cs(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,aux.TRUE,1,e:GetHandler()) end
	local g=Duel.SelectReleaseGroup(tp,aux.TRUE,1,2,e:GetHandler())
	Duel.Release(g,REASON_COST)
	e:GetHandler():RegisterFlagEffect(s_id,RESET_EVENT+0x1fe0000+RESET_CHAIN,0,0,g:GetCount())
end

function scard.a_op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() and c:GetFlagEffect(s_id)~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(c:GetFlagEffectLabel(s_id)*2)
		c:RegisterEffect(e1)
	end
end

function scard.b_cd(e)
	return aux.IsDualState(e) and e:GetHandler():IsLevelAbove(5)
end

function scard.c_cd(e)
	return aux.IsDualState(e) and e:GetHandler():IsLevelAbove(7)
end

function scard.c_tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE,e:GetHandler(),0,0,1000)
	Duel.SetOperationInfo(0,CATEGORY_DEFCHANGE,e:GetHandler(),0,0,1000)
end

function scard.c_op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)
		e1:SetValue(1000)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		c:RegisterEffect(e2)
	end
end
