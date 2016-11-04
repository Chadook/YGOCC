--Neo Paintress Goghi
function c500314819.initial_effect(c)
	c:EnableReviveLimit()
	c:EnableCounterPermit(0x88)
		--atk
	local e99=Effect.CreateEffect(c)
	e99:SetDescription(aux.Stringid(500314819,1))
	e99:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DISABLE)
	e99:SetType(EFFECT_TYPE_QUICK_O)
	e99:SetCode(EVENT_FREE_CHAIN)
	e99:SetRange(LOCATION_MZONE)
	e99:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e99:SetHintTiming(TIMING_DAMAGE_STEP,TIMING_DAMAGE_STEP+0x1c0)
	e99:SetCountLimit(1)
	e99:SetCost(c500314819.cost)
	e99:SetCondition(c500314819.condition)
	e99:SetTarget(c500314819.target)
	e99:SetOperation(c500314819.operation)
	c:RegisterEffect(e99)
		--evolute summon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(500314819,0))
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetCondition(c500314819.descon)
	e4:SetCost(c500314819.descost)
	e4:SetTarget(c500314819.destg)
	e4:SetOperation(c500314819.desop)
	c:RegisterEffect(e4)
	if not c500314819.global_check then
		c500314819.global_check=true
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_ADJUST)
		ge2:SetCountLimit(1)
		ge2:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
		ge2:SetOperation(c500314819.chk)
		Duel.RegisterEffect(ge2,0)
	end
end
c500314819.evolute=true
c500314819.material1=function(mc) return mc:IsAttribute(ATTRIBUTE_LIGHT) and mc:IsType(TYPE_NORMAL) and mc:GetLevel()==4 and mc:IsFaceup() end
c500314819.material2=function(mc) return mc:IsAttribute(ATTRIBUTE_LIGHT) and mc:IsType(TYPE_NORMAL) and mc:GetLevel()==4 and mc:IsFaceup() end
function c500314819.chk(e,tp,eg,ep,ev,re,r,rp)
	Duel.CreateToken(tp,388)
	Duel.CreateToken(1-tp,388)
end
function c500314819.descon(e,tp,eg,ep,ev,re,r,rp)
return  e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+388
end
function c500314819.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCurrentPhase()~=PHASE_MAIN2 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_BP)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c500314819.deesfilter(c)
return c:IsFaceup() and c:IsDestructable()
end
function c500314819.destg(e,tp,eg,ep,ev,re,r,rp,chk)
if chk==0 then return true end
local g=Duel.GetMatchingGroup(c500314819.deesfilter,tp,LOCATION_MZONE,LOCATION_MZONE,e:GetHandler())
Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c500314819.desop(e,tp,eg,ep,ev,re,r,rp)
local g=Duel.GetMatchingGroup(c500314819.deesfilter,tp,LOCATION_MZONE,LOCATION_MZONE,e:GetHandler())
if g:GetCount()>0 then
Duel.Destroy(g,REASON_EFFECT)
end
end
function c500314819.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()~=PHASE_DAMAGE or not Duel.IsDamageCalculated()
end
function c500314819.filter(c)
	return c:IsType(TYPE_EFFECT) and not (c:GetAttack()==0 and c:IsDisabled())
end
function c500314819.costfilter(c)
	return c:IsAbleToRemoveAsCost() and c:IsType(TYPE_NORMAL) or (c:IsType(TYPE_NORMAL+TYPE_PENDULUM) and c:IsFaceup())
end
function c500314819.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x88,3,REASON_COST) and Duel.IsExistingMatchingCard(c500314819.costfilter,tp,LOCATION_HAND+LOCATION_EXTRA,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c500314819.costfilter,tp,LOCATION_HAND+LOCATION_EXTRA,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	e:GetHandler():RemoveCounter(tp,0x88,3,REASON_COST)
end
function c500314819.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c500314819.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c500314819.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c500314819.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,e:GetHandler())
end
function c500314819.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(0)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
			local e0=Effect.CreateEffect(c)
		e0:SetType(EFFECT_TYPE_SINGLE)
		e0:SetCode(EFFECT_SET_DEFENSE_FINAL)
		e0:SetValue(0)
		e0:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e0)
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_DISABLE_EFFECT)
		e3:SetValue(RESET_TURN_SET)
		e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e3)
		if tc:IsType(TYPE_TRAPMONSTER) then
			local e4=Effect.CreateEffect(c)
			e4:SetType(EFFECT_TYPE_SINGLE)
			e4:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			e4:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e4)
		end
	end
end
