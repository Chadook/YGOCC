--Carefree Restforest
function c83030019.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Decrease atk/def
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(c83030019.atkdef)
	e2:SetValue(-300)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)
	--avoid battle damage
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e4:SetRange(LOCATION_SZONE)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetTargetRange(1,1)
	e4:SetCondition(c83030019.bdcon)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	--[[cannot change control (not working)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_CANNOT_CHANGE_CONTROL)
	e5:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e5:SetRange(LOCATION_SZONE)
	e5:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e5:SetValue(c83030019.ctval)
	c:RegisterEffect(e5)]]
	--Add to hand
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(83030016,0))
	e5:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCountLimit(1,83030019)
	e5:SetCost(c83030019.thcost)
	e5:SetTarget(c83030019.thtg)
	e5:SetOperation(c83030019.thop)
	c:RegisterEffect(e5)
	--Restrict material - player
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetRange(LOCATION_SZONE)	
	e6:SetTargetRange(0xff,0xff)
	e6:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e6:SetTarget(c83030019.mattg1)
	e6:SetValue(c83030019.matlimit1)
	c:RegisterEffect(e6)
	local e7=e6:Clone()
	e7:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	c:RegisterEffect(e7)
	local e8=e6:Clone()
	e8:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	c:RegisterEffect(e8)
	--Restrict material - opp
	local e9=e6:Clone()
	e9:SetTarget(c83030019.mattg2)
	e9:SetValue(c83030019.matlimit2)
	c:RegisterEffect(e9)
	local e10=e9:Clone()
	e10:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	c:RegisterEffect(e10)
	local e11=e9:Clone()
	e11:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	c:RegisterEffect(e11)
	--Reuse
	local e12=Effect.CreateEffect(c)
	e12:SetDescription(aux.Stringid(83030016,1))
	e12:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e12:SetCode(EVENT_TO_GRAVE)
	e12:SetCountLimit(1,83030021)
	e12:SetCondition(c83030019.retcon)
	e12:SetOperation(c83030019.retop)
	c:RegisterEffect(e12)
end
function c83030019.atkdef(e,c)
	return c:IsFaceup() and not c:IsSetCard(0x833)
end
function c83030019.costfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x833) and c:IsReleasable() and c:GetOwner()==tp
end
function c83030019.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c83030019.costfilter,tp,0,LOCATION_MZONE,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,c83030019.costfilter,tp,0,LOCATION_MZONE,1,1,nil,tp)
	Duel.Release(g,REASON_COST)
end
function c83030019.thfilter(c)
	return c:IsSetCard(0x833) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c83030019.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c83030019.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c83030019.thop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c83030019.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c83030019.retcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsReason(REASON_RETURN) and e:GetHandler():IsPreviousPosition(POS_FACEUP)
end
function c83030019.retop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return false end
	local fc=Duel.GetFieldCard(1-tp,LOCATION_SZONE,5)
	if fc then
		Duel.SendtoGrave(fc,REASON_RULE)
		Duel.BreakEffect()
	end
	Duel.MoveToField(c,1-tp,1-tp,LOCATION_SZONE,POS_FACEUP,true)
	Duel.RaiseEvent(c,EVENT_CHAIN_SOLVED,c:GetActivateEffect(),0,tp,1-tp,Duel.GetCurrentChain())
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+0x47e0000)
	e1:SetValue(LOCATION_DECKBOT)
	c:RegisterEffect(e1,true)
end
function c83030019.ctval(e,re)
	return not re:GetOwner():IsSetCard(0x833)
end
function c83030019.bdcon(e)
	if not Duel.GetAttackTarget() then return false end
	return Duel.GetAttacker():IsSetCard(0x833) and Duel.GetAttackTarget():IsSetCard(0x833)
end
function c83030019.mattg1(e,c)
	return c:GetOwner()~=e:GetHandlerPlayer()
end
function c83030019.matlimit1(e,c)
	if not c then return false end
	return c:GetOwner()==e:GetHandlerPlayer()
end
function c83030019.mattg2(e,c)
	return c:GetOwner()==e:GetHandlerPlayer()
end
function c83030019.matlimit2(e,c)
	if not c then return false end
	return c:GetOwner()~=e:GetHandlerPlayer()
end
