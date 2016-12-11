--Night Clock Knight
function c90000021.initial_effect(c)
	--Fusion Material
	aux.AddFusionProcFunFunRep(c,c90000021.mfilter1,c90000021.mfilter2,3,3,true)
	c:EnableReviveLimit()
	--Pendulum Limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetRange(LOCATION_PZONE)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c90000021.tg)
	c:RegisterEffect(e1)
	--Pendulum Summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_SPSUMMON_PROC_G)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1,90000021)
	e2:SetCondition(c90000021.pcondition)
	e2:SetOperation(c90000021.poperation)
	e2:SetValue(SUMMON_TYPE_PENDULUM)
	c:RegisterEffect(e2)
	--Avoid Damage
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e3:SetRange(LOCATION_PZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_FUSION))
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--Destroy
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetCondition(c90000021.condition)
	e4:SetTarget(c90000021.target)
	e4:SetOperation(c90000021.operation)
	c:RegisterEffect(e4)
	--ATK Up
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetCode(EFFECT_UPDATE_ATTACK)
	e5:SetRange(LOCATION_MZONE)
	e5:SetValue(c90000021.operation2)
	c:RegisterEffect(e5)
	--Pendulum Zone
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_DESTROY)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetProperty(EFFECT_FLAG_DELAY)
	e6:SetCode(EVENT_DESTROYED)
	e6:SetCondition(c90000021.condition2)
	e6:SetTarget(c90000021.target2)
	e6:SetOperation(c90000021.operation3)
	c:RegisterEffect(e6)
end
function c90000021.mfilter1(c)
	return c:IsType(TYPE_FUSION) and c:GetLevel()>=7
end
function c90000021.mfilter2(c)
	return c:IsType(TYPE_PENDULUM)
end
function c90000021.tg(e,c,sump,sumtype,sumpos,targetp)
	return not (c:IsSetCard(0x3) and c:IsType(TYPE_MONSTER)) and bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c90000021.pfilter(c,e,tp,lscale,rscale)
	local lv=0
	if c.pendulum_level then
		lv=c.pendulum_level
	else
		lv=c:GetLevel()
	end
	return (c:IsLocation(LOCATION_HAND) or c:IsLocation(LOCATION_GRAVE) or (c:IsFaceup() and c:IsType(TYPE_PENDULUM)))
		and lv>lscale and lv<rscale and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_PENDULUM,tp,false,false) and not c:IsForbidden()
end
function c90000021.pcondition(e,c,og)
	if c==nil then return true end
	local tp=c:GetControler()
	if c:GetSequence()~=6 then return false end
	local rpz=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
	if rpz==nil then return false end
	local lscale=c:GetLeftScale()
	local rscale=rpz:GetRightScale()
	if lscale>rscale then lscale,rscale=rscale,lscale end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return false end
	if og then
		return og:IsExists(c90000021.pfilter,1,nil,e,tp,lscale,rscale)
	else
		return Duel.IsExistingMatchingCard(c90000021.pfilter,tp,LOCATION_HAND+LOCATION_EXTRA+LOCATION_GRAVE,0,1,nil,e,tp,lscale,rscale)
	end
end
function c90000021.poperation(e,tp,eg,ep,ev,re,r,rp,c,sg,og)
	local rpz=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
	local lscale=c:GetLeftScale()
	local rscale=rpz:GetRightScale()
	if lscale>rscale then lscale,rscale=rscale,lscale end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if og then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=og:FilterSelect(tp,c90000021.pfilter,1,ft,nil,e,tp,lscale,rscale)
		sg:Merge(g)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c90000021.pfilter,tp,LOCATION_HAND+LOCATION_EXTRA+LOCATION_GRAVE,0,1,ft,nil,e,tp,lscale,rscale)
		sg:Merge(g)
	end
	Duel.HintSelection(Group.FromCards(c))
	Duel.HintSelection(Group.FromCards(rpz))
end
function c90000021.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_FUSION and re:GetHandler():IsCode(48130397)
end
function c90000021.filter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsDestructable()
end
function c90000021.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c90000021.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
	local g=Duel.GetMatchingGroup(c90000021.filter2,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c90000021.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c90000021.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
	Duel.Destroy(g,REASON_EFFECT)
end
function c90000021.filter2(c)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM)
end
function c90000021.operation2(e)
	return Duel.GetMatchingGroupCount(c90000021.filter2,0,LOCATION_EXTRA,LOCATION_EXTRA,nil)*300
end
function c90000021.condition2(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0 and e:GetHandler():IsPreviousLocation(LOCATION_MZONE)
end
function c90000021.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_SZONE,6) or Duel.CheckLocation(tp,LOCATION_SZONE,7) end
end
function c90000021.operation3(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckLocation(tp,LOCATION_SZONE,6) and not Duel.CheckLocation(tp,LOCATION_SZONE,7) then return false end
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end