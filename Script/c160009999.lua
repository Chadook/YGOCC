--Paintress Amersterdima
function c160009999.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--splimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c160009999.splimit)
	e2:SetCondition(c160009999.splimcon)
	c:RegisterEffect(e2)
	--actlimit
--Negate
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(160009999,1))
	e4:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetRange(LOCATION_PZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(c160009999.condition)
	e4:SetCost(c160009999.cost)
	e4:SetTarget(c160009999.target)
	e4:SetOperation(c160009999.operation)
	c:RegisterEffect(e4)
end
function c160009999.splimit(e,c,sump,sumtype,sumpos,targetp)
	if c:IsSetCard(0xc50) or c:IsType(TYPE_NORMAL) then return false end
	return bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c160009999.splimcon(e)
	return not e:GetHandler():IsForbidden()
end
function c160009999.condition(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_MONSTER)
end
function c160009999.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	   if chk==0 then return Duel.IsExistingMatchingCard(c160009999.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local cg=Duel.SelectMatchingCard(tp,c160009999.cfilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.Remove(cg,POS_FACEUP,REASON_COST)
end
function c160009999.cfilter(c)
	return   c:IsSetCard(0xc50) or c:IsType(TYPE_NORMAL) and c:IsAbleToRemoveAsCost()
end
function c160009999.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c160009999.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetCurrentChain()~=ev+1 then return	end
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_RULE)
	end
end

