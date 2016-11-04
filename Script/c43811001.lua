--Monster of the Phantasm
function c43811001.initial_effect(c)
	--Indes.
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e1:SetCountLimit(1)
	e1:SetValue(c43811001.valcon)
	c:RegisterEffect(e1)
	--Attack Gain 1
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(43811001,0))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE+LOCATION_HAND)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetHintTiming(TIMING_DAMAGE_STEP,TIMING_DAMAGE_STEP+0x1c0)
	e2:SetCountLimit(1)
	e2:SetCondition(c43811001.atkcon)
	e2:SetCost(c43811001.atkcost)
	e2:SetOperation(c43811001.atkop)
	c:RegisterEffect(e2)
	--Attack Gain 2
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetDescription(aux.Stringid(43811001,1))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,43811001)
	e3:SetCondition(c43811001.condition)
	e3:SetTarget(c43811001.target)
	e3:SetOperation(c43811001.operation)
	c:RegisterEffect(e3)
end
function c43811001.valcon(e,re,r,rp)
	return bit.band(r,REASON_EFFECT)~=0
end
function c43811001.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()~=PHASE_DAMAGE or not Duel.IsDamageCalculated()
end
function c43811001.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c43811001.afilter(c)
	return c:IsFaceup() and c:IsSetCard(0x90e)
end
function c43811001.atkop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(43811001,0))
	local op=Duel.SelectOption(tp,aux.Stringid(43811001,1),aux.Stringid(43811001,2))
	if op==1 then
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e2:SetTargetRange(LOCATION_MZONE,0)
		e2:SetTarget(c43811001.atktg)
		e2:SetValue(1)
		if Duel.GetTurnCount()>=2 then
			e2:SetReset(RESET_PHASE+PHASE_BATTLE)
		else
			e2:SetReset(RESET_PHASE+PHASE_END)
		end
		Duel.RegisterEffect(e2,tp)
	else
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetTargetRange(LOCATION_MZONE,0)
		e1:SetTarget(c43811001.atktg)
		e1:SetValue(700)
		if Duel.GetTurnCount()>=2 then
			e1:SetReset(RESET_PHASE+PHASE_BATTLE)
		else
			e1:SetReset(RESET_PHASE+PHASE_END)
		end
		Duel.RegisterEffect(e1,tp)
	end
end
function c43811001.atktg(e,c)
	return c:IsSetCard(0x90e)
end
function c43811001.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_EFFECT)
end
function c43811001.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x90e)
end
function c43811001.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c43811001.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c43811001.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c43811001.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c43811001.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(500)
		tc:RegisterEffect(e1)
	end
end
