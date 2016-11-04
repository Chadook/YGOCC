--Galaxy-Eyes Tachyon Binary Pulsar Dragon
function c405109.initial_effect(c)
	--Synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(c405109.mfilter),aux.NonTuner(c405109.mfilter2),1)
	c:EnableReviveLimit()
	--Atk
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(405109,0))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_QUICK_O+EFFECT_TYPE_FIELD)
	e1:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c405109.condition)
	e1:SetCost(c405109.cost)
	e1:SetOperation(c405109.operation)
	c:RegisterEffect(e1)
	--Recover
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(405109,1))
	e2:SetCategory(CATEGORY_RECOVER)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_BATTLE_DAMAGE)
	e2:SetCondition(c405109.con)
	e2:SetTarget(c405109.tg)
	e2:SetOperation(c405109.op)
	c:RegisterEffect(e2)
	--Banish
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(405109,2))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BE_BATTLE_TARGET)
	e3:SetCountLimit(1,405109)
	e3:SetTarget(c405109.rtg)
	e3:SetOperation(c405109.rop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EVENT_BECOME_TARGET)
	e4:SetCondition(c405109.rcon)
	c:RegisterEffect(e4)
end
function c405109.mfilter(c)
	return c:IsSetCard(0x7b)
end
function c405109.mfilter2(c)
	return c:IsSetCard(0x55) or c:IsSetCard(0x7b)
end
function c405109.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetFlagEffect(405109)==0 and (Duel.GetAttackTarget()==c or (Duel.GetAttacker()==c) and Duel.GetAttackTarget()~=nil)
end
function c405109.cfilter(c)
	return (c:IsSetCard(0x107b) and c:IsAbleToDeckAsCost()) or (c:IsAbleToExtraAsCost() and c:IsSetCard(0x107b)) and (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup())
end
function c405109.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(405109)==0
		and Duel.IsExistingMatchingCard(c405109.cfilter,tp,LOCATION_GRAVE+LOCATION_MZONE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c405109.cfilter,tp,LOCATION_GRAVE+LOCATION_MZONE,0,1,1,e:GetHandler())
	e:SetLabel(g:GetFirst():GetAttack())
	Duel.SendtoDeck(g,nil,1,REASON_COST)
	e:GetHandler():RegisterFlagEffect(405109,RESET_PHASE+PHASE_DAMAGE_CAL,0,1)
end
function c405109.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(e:GetLabel()/2)
		e1:SetReset(RESET_PHASE+PHASE_DAMAGE_CAL)
		c:RegisterEffect(e1)
	end
end
function c405109.con(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp 
end
function c405109.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(ev)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,ev)
end
function c405109.op(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end
function c405109.rcon(e,tp,eg,ep,ev,re,r,rp)
  return eg:IsContains(e:GetHandler())
end
function c405109.rtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,e:GetHandler(),1,0,0)
end
function c405109.rop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsControler(tp) and Duel.Remove(c,nil,REASON_EFFECT+REASON_TEMPORARY)~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetLabelObject(c)
		e1:SetCountLimit(1)
		e1:SetOperation(c405109.retop)
		Duel.RegisterEffect(e1,tp)
	end
end
function c405109.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ReturnToField(e:GetLabelObject())
end