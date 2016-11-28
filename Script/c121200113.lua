--Guardian of the Flora - Painsetta
--  Idea: Aslan
--  Script: Shad3
--[[
This card is treated as a Normal Monster while face-up on the field or in the Graveyard or Extra Deck. While this card is a Normal Monster on the field, you can Normal Summon it to have it become an Effect Monster with these effects.
● Once per turn: You can Tribute other monsters you control (max. 2); increase this card's Level by twice the amount of the Tributed monsters, as long as this card is face-up on the field.
● This Level 5 or higher card cannot be destroyed by battle.
● If this card is Level 7 or higher, it gains 1000 ATK and DEF.
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
	--Indestructible
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetDescription(aux.Stringid(s_id,1))
	e2:SetCondition(scard.b_cd)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--1000ATK/DEF
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetDescription(aux.Stringid(s_id,2))
	e3:SetCondition(scard.c_cd)
	e3:SetValue(1000)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_UPDATE_DEFENSE)
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
