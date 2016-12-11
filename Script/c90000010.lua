--Night Clock Queen
function c90000010.initial_effect(c)
	--Fusion Material
	aux.AddFusionProcFunRep(c,c90000010.mfilter,3,false)
	c:EnableReviveLimit()
	--Summon Condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c90000010.value)
	c:RegisterEffect(e1)
	--ATK /2
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c90000010.condition)
	e2:SetTarget(c90000010.target)
	e2:SetOperation(c90000010.operation)
	c:RegisterEffect(e2)
	--Negate Attack
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_BE_BATTLE_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetOperation(c90000010.operation2)
	c:RegisterEffect(e3)
	--Negate Effect
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_REMOVE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_BECOME_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c90000010.condition2)
	e4:SetOperation(c90000010.operation3)
	c:RegisterEffect(e4)
	--Special Summon
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e5:SetCode(EVENT_PHASE+PHASE_END)
	e5:SetRange(LOCATION_REMOVED)
	e5:SetCountLimit(1)
	e5:SetCondition(c90000010.condition3)
	e5:SetTarget(c90000010.target2)
	e5:SetOperation(c90000010.operation4)
	c:RegisterEffect(e5)
	--Destroy
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_DESTROY)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1)
	e6:SetTarget(c90000010.target3)
	e6:SetOperation(c90000010.operation5)
	c:RegisterEffect(e6)
end
function c90000010.mfilter(c)
	return c:IsFusionSetCard(0x3) and c:IsType(TYPE_FUSION)
end
function c90000010.value(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA) or bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c90000010.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_FUSION
end
function c90000010.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler()) end
end
function c90000010.operation(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,e:GetHandler())
	local tc=tg:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(tc:GetAttack()/2)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		tc=tg:GetNext()
	end
end
function c90000010.operation2(e,tp,eg,ep,ev,re,r,rp,chk)
	Duel.NegateAttack()
	if e:GetHandler():IsRelateToEffect(e) and Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)~=0 then
		e:GetHandler():RegisterFlagEffect(90000010,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
	end
end
function c90000010.condition2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsContains(e:GetHandler())
end
function c90000010.operation3(e,tp,eg,ep,ev,re,r,rp,chk)
	Duel.NegateActivation(ev)
	if e:GetHandler():IsRelateToEffect(e) and Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)~=0 then
		e:GetHandler():RegisterFlagEffect(90000010,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
	end
end
function c90000010.condition3(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(90000010)~=0
end
function c90000010.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c90000010.operation4(e,tp,eg,ep,ev,re,r,rp,chk)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
	end
end
function c90000010.target3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
	local g=Duel.GetMatchingGroup(Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c90000010.operation5(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
	Duel.Destroy(g,REASON_EFFECT)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c90000010.tg)
	e1:SetLabel(e:GetHandler():GetFieldID())
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c90000010.tg(e,c)
	return e:GetLabel()~=c:GetFieldID()
end